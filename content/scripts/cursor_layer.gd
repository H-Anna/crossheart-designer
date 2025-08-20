class_name XStitchCursorLayer
extends XStitchMasterLayer

## A special layer that draws the cursor in real-time, providing visual feedback
## to the user.

@onready var _sublayer = %FullStitchLayer

var focused := true
var _erasing := false
var _active_cell : Vector2i
var _brush_size : int
# TODO: connect thread select signal

func _ready() -> void:
	SignalBus.canvas_focus_changed.connect(_focus_changed)
	pass

func _process(_delta: float) -> void:
	if !focused:
		return
	
	# Don't draw anything if no thread is selected.
	if !Globals.canvas.thread:
		return
	
	if Input.is_action_just_pressed("erase"):
		_erasing = true
	elif Input.is_action_just_released("erase"):
		_erasing = false
	
	_update_cursor_position()
	_draw_cursor()

func _focus_changed(_focused: bool):
	focused = _focused
	
	if !focused:
		_erase_cursor()

func _erase_cursor():
	_sublayer.erase_all()

func _update_cursor_position():
	var current_cell = _sublayer.local_to_map(get_global_mouse_position())
	# Determine if an update is necessary.
	# It's only necessary when the cell under the cursor changed,
	# or the brush size changed.
	if _active_cell == current_cell && _brush_size == Globals.canvas.brush_size:
		return
	
	_active_cell = current_cell
	_brush_size = Globals.canvas.brush_size

func _draw_cursor():
	_sublayer.erase_all()
	if !_erasing:
		_sublayer.draw_stitch(Globals.canvas.thread, _active_cell, Globals.canvas.bounding_rect, _brush_size)
