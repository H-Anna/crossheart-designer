extends ContextMenu

const SWAP = 0
const CHANGE_SYMBOL = 1
const DELETE = 3

func _ready() -> void:
	SignalBus.skein_swap_requested.connect(_swap_thread)

func _on_id_pressed(id: int) -> void:
	match id:
		SWAP:
			%PaletteMenu.hide()
			%SwapThreadMenu.show()
		CHANGE_SYMBOL:
			%PaletteMenu.hide()
			%SwapThreadMenu.show()
		DELETE:
			_delete_thread()
		_:
			print_debug("Unhandled id: %s" % id)

# TODO: create scripts for the confirmation dialogs
func _delete_thread() -> void:
	var confirm_sig = %DeleteThreadConfirmationDialog.confirmed
	var canceled_sig = %DeleteThreadConfirmationDialog.canceled
	var emit_callable = SignalBus.skein_removed_from_palette.emit
	
	Extensions.disconnect_all(confirm_sig)
	Extensions.disconnect_all(canceled_sig)
	
	confirm_sig.connect(emit_callable.bind(caller.thread))
	
	%DeleteThreadConfirmationDialog.show()

func _swap_thread(target: Skein) -> void:
	var confirm_sig = %SwapThreadConfirmationDialog.confirmed
	var canceled_sig = %SwapThreadConfirmationDialog.canceled
	var emit_callable = SignalBus.skein_swapped.emit
	
	Extensions.disconnect_all(confirm_sig)
	Extensions.disconnect_all(canceled_sig)
	
	confirm_sig.connect(emit_callable.bind(caller.thread, target))
	confirm_sig.connect(%PaletteMenu.show)
	confirm_sig.connect(%SwapThreadMenu.hide)
	
	%SwapThreadConfirmationDialog.show()
