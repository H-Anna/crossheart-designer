class_name XStitchCursorLayer
extends XStitchMasterLayer

## A special layer that draws the cursor in real-time, providing visual feedback
## to the user.

## The canvas to which this layer belongs.
@onready var canvas : XStitchCanvas = $"../.."
var _active_cell : Vector2i
var _brush_size : int
var _drawing : bool = false
# TODO: connect thread select signal

func _ready() -> void:
	_brush_size = canvas.brush_size

func _process(delta: float) -> void:
	if !canvas.can_draw:
		return
	
	# Don't draw anything if no thread is selected.
	if !canvas.thread:
		return
	
	if Input.is_action_just_pressed("draw"):
		_drawing = true
	elif Input.is_action_just_released("draw"):
		_drawing = false
	
	_update_cursor()

func _update_cursor():
	# Get mouse position on tilemap
	var current_cell = %FullStitchLayer.local_to_map(get_global_mouse_position())
	
	# Determine if an update is necessary.
	# It's only necessary when the cell under the cursor changed,
	# or the brush size changed.
	if _active_cell == current_cell && _brush_size == canvas.brush_size:
		return
	
	if !_drawing:
		%FullStitchLayer.erase_all()
	_active_cell = current_cell
	_brush_size = canvas.brush_size
	
	# Highlight current cell
	%FullStitchLayer.draw_stitch(canvas.thread, current_cell, canvas.bounding_rect, _brush_size)
