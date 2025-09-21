class_name ThreadContextMenu
extends ContextMenu
## Context menu for [ThreadButton]s 
## and corresponding [XStitchThread]s.

## "Swap" menu option.
## Allows the user to swap the chosen thread
## in the palette for another one.[br]
const SWAP = 0

## @experimental: This option doesn't do anything yet.
## "Change symbol" menu option.
## Allows the user to change the [XStitchSymbol] associated
## with this [XStitchThread].[br]
const CHANGE_SYMBOL = 1

## "Delete" menu option.
## Selecting this deletes the chosen thread from the palette.[br]
const DELETE = 3

## Called when one of the options is selected.
func _on_id_pressed(id: int) -> void:
	match id:
		SWAP:
			SignalBus.thread_swap_in_progress.emit(caller.thread)
			%PaletteMenu.hide()
			%SwapThreadMenu.show()
			var target = await SignalBus.thread_swap_requested
			%SwapThreadConfirmationDialog.confirm(caller.thread, target)
		CHANGE_SYMBOL:
			pass #TODO: implement
		DELETE:
			%DeleteThreadConfirmationDialog.confirm(caller.thread)
		_:
			print_debug("Unhandled id: %s" % id)
