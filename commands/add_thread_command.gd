class_name AddThreadCommand
extends Command

var thread: XStitchThread

func execute():
	Globals.palette_controller.add_thread(thread)
	Globals.palette_controller.select_thread(thread)
	print_debug("CMD DO: ", get_string())

func undo():
	Globals.palette_controller.remove_thread(thread)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Add thread %s" % [thread.get_identifying_name()]
