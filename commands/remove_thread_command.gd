class_name RemoveThreadCommand
extends Command

var thread: XStitchThread
var palette: PaletteModel
var palette_controller: PaletteController
var canvas: XStitchCanvas
var context: Dictionary

var _was_selected: bool

func execute():
	_was_selected = palette.selected_thread == thread
	palette_controller.remove_thread(thread)
	context = canvas.remove_stitches(thread)
	print_debug("CMD DO: ", get_string())

func undo():
	palette_controller.add_thread(thread)
	if _was_selected:
		palette.selected_thread = thread
	canvas.add_stitches(thread, context)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Remove thread %s" % [thread.get_identifying_name()]
