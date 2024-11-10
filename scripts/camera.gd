extends Camera2D

@export var value : float = 0.1
@export var minimum_zoom := 0.2
@export var maximum_zoom := 5.0

var can_zoom := true

func _ready() -> void:
	SignalBus.canvas_focus_changed.connect(func(focused): can_zoom = focused)

func _process(_delta: float) -> void:
	update_zoom()

func resize_zoom(_value: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var new_zoom = zoom + Vector2(_value, _value)
	zoom = new_zoom.clamp(Vector2(minimum_zoom, minimum_zoom), Vector2(maximum_zoom, maximum_zoom))
	var new_mouse_pos := get_global_mouse_position()
	position += mouse_pos - new_mouse_pos

func update_zoom():
	if !can_zoom:
		return
	
	if Input.is_action_just_pressed("zoom-in", true):
		resize_zoom(value)
	if Input.is_action_just_pressed("zoom-out", true):
		resize_zoom(-value)
