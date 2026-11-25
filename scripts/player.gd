extends CharacterBody3D

signal keys_changed(current_keys: int, target_keys: int)
signal gate_unlocked

const SPEED: float = 5.5
const JUMP_VELOCITY: float = 4.8
const TARGET_KEYS: int = 3
const ROTATION_SPEED: float = 12.0
const MOUSE_SENSITIVITY: float = 0.004

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _keys: int = 0

@onready var camera_pivot: Node3D = $CameraPivot
@onready var model: Node3D = $"mannequiny-0_4_0"
@onready var anim_player: AnimationPlayer = $"mannequiny-0_4_0/AnimationPlayer"

func _ready() -> void:
	add_to_group("player")
	keys_changed.emit(_keys, TARGET_KEYS)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_play_anim(["idle", "Idle"])

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		camera_pivot.rotation.x = clamp(
			camera_pivot.rotation.x - event.relative.y * MOUSE_SENSITIVITY,
			deg_to_rad(-45.0),
			deg_to_rad(35.0)
		)
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var cam_turn := Input.get_axis("ui_right", "ui_left")
	if cam_turn != 0.0:
		camera_pivot.rotate_y(cam_turn * 2.5 * delta)

	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var cam_basis := Basis(Vector3.UP, camera_pivot.rotation.y)
	var direction := (cam_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var target_angle := atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_angle, ROTATION_SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	_update_animation(direction)

func _update_animation(direction: Vector3) -> void:
	if anim_player == null:
		return
	if not is_on_floor():
		_play_anim(["air_jump", "jump", "Jump", "fall"])
	elif direction != Vector3.ZERO:
		_play_anim(["run", "Run", "walk", "Walk"])
	else:
		_play_anim(["idle", "Idle"])

func _play_anim(candidates: Array[String]) -> void:
	if anim_player == null:
		return
	for anim_name in candidates:
		if anim_player.has_animation(anim_name):
			if anim_player.current_animation != anim_name:
				anim_player.play(anim_name, 0.15)
			return

func add_key(amount: int = 1) -> void:
	_keys = clamp(_keys + amount, 0, TARGET_KEYS)
	keys_changed.emit(_keys, TARGET_KEYS)
	if _keys >= TARGET_KEYS:
		gate_unlocked.emit()

func get_keys() -> int:
	return _keys

func get_target_keys() -> int:
	return TARGET_KEYS
