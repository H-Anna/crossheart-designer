class_name XStitchMasterLayer
extends Node2D

var data: ThreadLayer
var active := false

func draw_stitch(thread: Skein, size: int, bounding_rect: Rect2i):
	# TODO: draw on layer based on tool, let layer handle drawing
	if !active: return
	if !thread: return
	if size == 0: return
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.draw_stitch(thread, pos, bounding_rect, size)
	pass

func erase_stitch(size: int, bounding_rect: Rect2i):
	# TODO: erase on layer based on tool
	if !active: return
	if size == 0: return
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.erase_stitch(pos, bounding_rect, size)
	pass
