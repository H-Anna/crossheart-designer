class_name SwapThreadCommand
extends Command

## Command to swap a thread for another, and replace all
## stitches of the old thread with the new one.

## Thread to replace.
var old_thread: XStitchThread

## Thread that replaces the old one.
var new_thread: XStitchThread

## The stitches and their locations on various layers, that need
## to be changed.
var context: Dictionary

## Swaps the threads on the palette. Removes stitches made with the
## previous thread, then adds stitches in the same place with the
## new thread.
func execute() -> void:
	Globals.palette_controller.swap_thread(old_thread, new_thread)
	context = Globals.canvas.remove_stitches(old_thread)
	Globals.canvas.add_stitches(new_thread, context)

## Restores state before the swap.
func undo() -> void:
	Globals.palette_controller.swap_thread(new_thread, old_thread)
	context = Globals.canvas.remove_stitches(new_thread)
	Globals.canvas.add_stitches(old_thread, context)
