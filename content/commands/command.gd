class_name Command
extends Resource

## Base class for commands performed in the cross stitch editor.

## Used to perform a series of operations associated with the command.
func execute() -> void:
	push_warning("Override this execute method!")

## Initiates operations that aim to do the "opposite" of [method execute].
func undo() -> void:
	push_warning("Override this undo method!")

## Prints a string associated with this command.
## Can be used to push debug messages.
func get_string() -> String:
	return "Override this method!"

## Checks if the command is valid based on its data.
## If not, the command manager discards it.
## True by default.
func is_valid() -> bool:
	return true
