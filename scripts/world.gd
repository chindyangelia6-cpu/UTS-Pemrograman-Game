extends Node3D

@onready var player: CharacterBody3D = $Player
@onready var hud: CanvasLayer = $HUD
@onready var gate: StaticBody3D = $Gate
@onready var keys_container: Node3D = $Keys

var _gate_opened: bool = false

func _ready() -> void:
	player.keys_changed.connect(hud.update_keys)
	player.gate_unlocked.connect(_on_gate_unlocked)
	hud.update_keys(player.get_keys(), player.get_target_keys())

	for key_node in keys_container.get_children():
		if key_node.has_signal("key_collected"):
			key_node.key_collected.connect(_on_key_collected)

func _on_key_collected(amount: int) -> void:
	player.add_key(amount)

func _on_gate_unlocked() -> void:
	if _gate_opened or not is_instance_valid(gate):
		return
	_gate_opened = true
	var tween := create_tween()
	tween.tween_property(gate, "position:y", gate.position.y + 4.5, 1.0).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(gate.queue_free)
