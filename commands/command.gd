class_name Command
extends Resource

## Base class for commands performed in the cross stitch editor.

## Executes the command.
func execute():
	push_warning("Override this execute method!")

## Undoes the command.
func undo():
	push_warning("Override this undo method!")
