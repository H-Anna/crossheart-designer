class_name RemoveThreadCommand
extends Command

var thread: XStitchThread
var palette: PaletteModel
var context: Dictionary

func execute():
	Globals.palette_controller.remove_thread(thread)
	context = Globals.canvas.remove_stitches(thread)
	
	print_debug("CMD DO: ", get_string())

func undo():
	Globals.palette_controller.add_thread(thread)
	Globals.canvas.add_stitches(thread, context)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Remove thread %s" % [thread.get_identifying_name()]
