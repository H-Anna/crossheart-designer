class_name AddThreadCommand
extends Command

var thread: XStitchThread
var symbol: XStitchSymbol

func execute():
	thread.symbol = symbol
	var index = Globals.palette_controller.add_thread(thread)
	Globals.palette_controller.select_thread(index)
	print_debug("CMD DO: ", get_string())

func undo():
	thread.symbol = null
	Globals.palette_controller.remove_thread(thread)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Add thread %s" % [thread.get_identifying_name()]
