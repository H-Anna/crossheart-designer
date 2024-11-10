class_name XStitchCursorLayer
extends XStitchMasterLayer

@onready var canvas : XStitchCanvas = get_parent()

var _active_cell : Vector2i
var _brush_size : int

func _ready() -> void:
	#SignalBus.ui_brush_size_changed.connect(_update_cursor)
	#SignalBus.brush_size_changed.connect(_update_cursor)
	_brush_size = canvas.brush_size

func _process(delta: float) -> void:
	_update_cursor()

func _update_cursor():
	if !canvas.thread:
		return
	
	## Get mouse position on tilemap
	var current_cell = %FullStitchLayer.local_to_map(get_global_mouse_position())
	
	## De-highlight previous cell
	if _active_cell != current_cell || _brush_size != canvas.brush_size:
		%FullStitchLayer.erase_all()
		_active_cell = current_cell
		_brush_size = canvas.brush_size
	
	## Highlight current cell
	%FullStitchLayer.draw_stitch(canvas.thread, current_cell, canvas.bounding_rect, _brush_size)
