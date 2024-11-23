extends ContextMenu

const SWAP = 0
const CHANGE_SYMBOL = 1
const DELETE = 3

func _on_id_pressed(id: int) -> void:
	match id:
		SWAP:
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
