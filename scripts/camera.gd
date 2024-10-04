extends Camera2D

@export var value : float = 0.1
@export var minimum_zoom := 0.2
@export var maximum_zoom := 5.0
@export var focus_mode : Helpers.MouseFocusMode

signal zoom_level_changed(value: float)

func _ready() -> void:
	SignalBus.focus_changed.connect(_apply_focus_change)
	resize_zoom(0)

func _process(_delta: float) -> void:
	update_zoom()

func _apply_focus_change(mode: int):
	match mode:
		focus_mode: set_process(true)
		_: set_process(false)

func resize_zoom(_value: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var new_zoom = zoom + Vector2(_value, _value)
	zoom = new_zoom.clamp(Vector2(minimum_zoom, minimum_zoom), Vector2(maximum_zoom, maximum_zoom))
	var new_mouse_pos := get_global_mouse_position()
	position += mouse_pos - new_mouse_pos
	zoom_level_changed.emit(zoom.length())

func update_zoom():
	if Input.is_action_just_pressed("zoom-in") && !Input.is_action_just_pressed("increase-brush-size"):
		resize_zoom(value)
	if Input.is_action_just_pressed("zoom-out") && !Input.is_action_just_pressed("decrease-brush-size"):
		resize_zoom(-value)
