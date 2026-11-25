extends CanvasLayer

@onready var key_label: Label = $UIContainer/KeyLabel
@onready var status_label: Label = $UIContainer/StatusLabel
@onready var settings_button: Button = $UIContainer/SettingsButton
@onready var settings_panel: Panel = $UIContainer/SettingsPanel
@onready var sfx_slider: HSlider = $UIContainer/SettingsPanel/VBoxContainer/SFXSlider
@onready var sfx_value_label: Label = $UIContainer/SettingsPanel/VBoxContainer/SFXValueLabel

var _sfx_bus_index: int = -1

func _ready() -> void:
	_sfx_bus_index = AudioServer.get_bus_index("SFX")
	settings_panel.visible = false
	status_label.visible = false
	settings_button.pressed.connect(_on_settings_pressed)
	sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	_on_sfx_slider_changed(sfx_slider.value)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_TAB or event.keycode == KEY_M:
			_on_settings_pressed()

func update_keys(current_keys: int, target_keys: int) -> void:
	key_label.text = "Kunci: %d/%d" % [current_keys, target_keys]
	if current_keys >= target_keys:
		status_label.text = "Gerbang Terbuka!"
		status_label.visible = true

func _on_settings_pressed() -> void:
	settings_panel.visible = not settings_panel.visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if settings_panel.visible else Input.MOUSE_MODE_CAPTURED

func _on_sfx_slider_changed(value: float) -> void:
	sfx_value_label.text = "Volume SFX: %d%%" % int(round(value * 100.0))
	if _sfx_bus_index != -1:
		AudioServer.set_bus_volume_db(_sfx_bus_index, linear_to_db(max(value, 0.0001)))
		AudioServer.set_bus_mute(_sfx_bus_index, value <= 0.0)
