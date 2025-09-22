class_name RemoveThreadCommand
extends Command

## Command to remove a thread from the palette.

## Thread to remove.
var thread: XStitchThread

## The stitches removed (as part of this command)
## from various layers and their original positions.
var context: Dictionary

## Removes the thread from the palette.
## Populates [member context] to prepare it for undoing.
func execute() -> void:
	Globals.palette_controller.remove_thread(thread)
	context = Globals.canvas.remove_stitches(thread)
	
	print_debug("CMD DO: ", get_string())

## Adds the thread back, as well as the stitches previously removed.
func undo() -> void:
	Globals.palette_controller.add_thread(thread)
	Globals.canvas.add_stitches(thread, context)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Remove thread %s" % [thread.get_identifying_name()]
