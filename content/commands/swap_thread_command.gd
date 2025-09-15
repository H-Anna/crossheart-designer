class_name SwapThreadCommand
extends Command

var old_thread: XStitchThread
var new_thread: XStitchThread
var context: Dictionary

func execute():
	Globals.palette_controller.swap_thread(old_thread, new_thread)
	context = Globals.canvas.remove_stitches(old_thread)
	Globals.canvas.add_stitches(new_thread, context)

func undo():
	Globals.palette_controller.swap_thread(new_thread, old_thread)
	context = Globals.canvas.remove_stitches(new_thread)
	Globals.canvas.add_stitches(old_thread, context)
