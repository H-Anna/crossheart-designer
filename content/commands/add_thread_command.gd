class_name AddThreadCommand
extends Command

## Command that adds a thread to the palette.

## The thread to add.
var thread: XStitchThread

## The associated symbol.
var symbol: XStitchSymbol

## Adds the [member symbol] to the [member thread], and adds the [member thread]
## to the palette.
func execute() -> void:
	thread.symbol = symbol
	var index = Globals.palette_controller.add_thread(thread)
	Globals.palette_controller.select_thread(index)
	print_debug("CMD DO: ", get_string())

## Removes the thread from the palette, and the symbol from the thread.
func undo() -> void:
	thread.symbol = null
	Globals.palette_controller.remove_thread(thread)
	print_debug("CMD UNDO: ", get_string())

func get_string() -> String:
	return "Add thread %s" % [thread.get_identifying_name()]
