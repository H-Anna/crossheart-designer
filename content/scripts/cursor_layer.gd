class_name XStitchCursorLayer
extends XStitchMasterLayer

@onready var canvas : XStitchCanvas = get_parent()

var _active_cell : Vector2i

func _process(delta: float) -> void:
	if !canvas.cursor_thread:
		return
	
	## Get mouse position on tilemap
	var current_cell = %FullStitchLayer.local_to_map(get_global_mouse_position())
	
	## De-highlight previous cell
	if _active_cell != current_cell:
		%FullStitchLayer.erase_all()
		_active_cell = current_cell
	
	## Highlight current cell
	%FullStitchLayer.draw_stitch(canvas.cursor_thread, current_cell, canvas.bounding_rect, canvas.cursor_size)
	pass
