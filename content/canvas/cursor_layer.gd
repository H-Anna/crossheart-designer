class_name XStitchCursorLayer
extends XStitchMasterLayer

## A special layer that draws the cursor in real-time, providing visual feedback
## to the user.

## The sublayer to draw the cursor on.
@onready var _sublayer = %FullStitchLayer

## Erasing mode hides the cursor.
var _erasing := false

## The cell the mouse is pointing at.
var _active_cell : Vector2i

## The current brush size.
var _brush_size : int

func _ready() -> void:
	pass

## Handles mouse input and draws the cursor in response.
func _unhandled_input(event: InputEvent) -> void:
	# Don't draw anything if no thread is selected.
	if !Globals.canvas.get_current_thread():
		return
	
	if event.is_action_pressed("erase", false, true):
		_erasing = true
	elif event.is_action_released("erase", true):
		_erasing = false
	
	_draw_cursor()

## Draws the cursor at the mouse pointer position.
func _draw_cursor():
	_sublayer.erase_all()
	if !_erasing:
		var thread = Globals.canvas.get_current_thread()
		var cell = _sublayer.local_to_map(get_global_mouse_position())
		var rect = Globals.canvas.bounding_rect
		var brush_size = Globals.canvas.brush_size
		_sublayer.draw_stitch(thread, cell, rect, brush_size)
