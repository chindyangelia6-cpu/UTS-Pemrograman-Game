extends Area3D

signal key_collected(amount: int)

@export var value: int = 1
@export var rotation_speed: float = 2.5

@onready var visual: Node3D = $KeyVisual
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var pickup_sound: AudioStreamPlayer = $PickupSound

var _is_collected: bool = false
var _time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_time += delta
	visual.rotate_y(rotation_speed * delta)
	visual.position.y = sin(_time * 3.0) * 0.1

func _on_body_entered(body: Node3D) -> void:
	if _is_collected:
		return
	if body.is_in_group("player") or body.name == "Player":
		_is_collected = true
		key_collected.emit(value)
		visual.visible = false
		collision.set_deferred("disabled", true)
		await _play_key_sfx()
		queue_free()

func _play_key_sfx() -> void:
	var gen := AudioStreamGenerator.new()
	gen.mix_rate = 44100.0
	gen.buffer_length = 0.25
	pickup_sound.stream = gen
	pickup_sound.play()
	var playback := pickup_sound.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback != null:
		var frames := int(gen.mix_rate * 0.22)
		for i in range(frames):
			var t := float(i) / gen.mix_rate
			var freq := 880.0 if t < 0.09 else 1318.5
			var env := 1.0 - (float(i) / float(frames))
			var sample := sin(TAU * freq * t) * 0.35 * env
			playback.push_frame(Vector2(sample, sample))
	await get_tree().create_timer(0.24).timeout
