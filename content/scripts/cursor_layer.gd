class_name XStitchCursorLayer
extends XStitchMasterLayer

## A special layer that draws the cursor in real-time, providing visual feedback
## to the user.

## The canvas to which this layer belongs.
@onready var canvas : XStitchCanvas = $"../.."
var _active_cell : Vector2i
var _brush_size : int
var _drawing : bool = false
var _erasing : bool = false
# TODO: connect thread select signal

func _ready() -> void:
	_brush_size = canvas.brush_size

func _process(_delta: float) -> void:
	if !canvas.can_draw:
		return
	
	# Don't draw anything if no thread is selected.
	if !canvas.thread:
		return
	
	if Input.is_action_just_pressed("draw"):
		if !canvas.active_layer.locked && canvas.active_layer.visible:
			_drawing = true
	elif Input.is_action_just_released("draw"):
		_drawing = false
	
	if Input.is_action_just_pressed("erase"):
		if !canvas.active_layer.locked && canvas.active_layer.visible:
			_erasing = true
	elif Input.is_action_just_released("erase"):
		_erasing = false
	
	_update_cursor_position()
	
	_draw_cursor()
	

func _copy_layer_contents():
	var sublayer = canvas.active_layer.get_active_sublayer()
	for cell in sublayer.get_used_cells():
		%FullStitchLayer.draw_pixel(sublayer.get_stitch_at(cell), cell)

func _update_cursor_position():
	var current_cell = %FullStitchLayer.local_to_map(get_global_mouse_position())
	# Determine if an update is necessary.
	# It's only necessary when the cell under the cursor changed,
	# or the brush size changed.
	if _active_cell == current_cell && _brush_size == canvas.brush_size:
		return
	
	_active_cell = current_cell
	_brush_size = canvas.brush_size

func _draw_cursor():
	if !_drawing || _erasing:
		%FullStitchLayer.erase_all()
		
	# Highlight cursor
	if _drawing || !_erasing:
		%FullStitchLayer.draw_stitch(canvas.thread, _active_cell, canvas.bounding_rect, _brush_size)
