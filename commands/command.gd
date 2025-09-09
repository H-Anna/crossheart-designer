class_name Command
extends Resource

## Base class for commands performed in the cross stitch editor.

## Used to perform a series of operations associated with the command.
func execute():
	push_warning("Override this execute method!")

## Initiates operations that aim to do the "opposite" of [method execute].
func undo():
	push_warning("Override this undo method!")

## Prints a string associated with this command.
## Can be used to push debug messages.
func get_string() -> String:
	return "Override this method!"
