extends Camera2D

## Handles the [XStitchCanvas] camera.

## Configurable value that is used for zooming in and out.
@export var value : float = 0.1

## The minimum zoom level. (Most zoomed out)
@export var minimum_zoom := 0.2

## The maximum zoom level. (Most zoomed in)
@export var maximum_zoom := 5.0

## Whether the camera can zoom at the moment. Can only zoom if the canvas
## receives mouse input focus.
var can_zoom := true

## Connects signal.
func _ready() -> void:
	SignalBus.canvas_focus_changed.connect(func(focused): can_zoom = focused)

## Handles zoom in and zoom out input, if the canvas receives focus.
func _unhandled_input(event: InputEvent) -> void:
	if !can_zoom:
		return
	
	if event.is_action_pressed("zoom-in", false, true):
		resize_zoom(value)
	if event.is_action_pressed("zoom-out", false, true):
		resize_zoom(-value)

## Changes camera position and zoom level.
func resize_zoom(_value: float) -> void:
	var mouse_pos := get_global_mouse_position()
	var new_zoom = zoom + Vector2(_value, _value)
	zoom = new_zoom.clamp(Vector2(minimum_zoom, minimum_zoom), Vector2(maximum_zoom, maximum_zoom))
	var new_mouse_pos := get_global_mouse_position()
	position += mouse_pos - new_mouse_pos
