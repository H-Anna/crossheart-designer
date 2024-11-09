extends ConfirmationDialog

## Setup for confirming the swap from [param old_thread]
## to [param new_thread].[br][br]
## Note: 
## Connecting to [signal ConfirmationDialog.confirmed] instead of awaiting it
## is necessary to prevent a bug where multiple methods wait for one
## emission of this signal, resulting in multiple threads being swapped.
func confirm(old_thread: Skein, new_thread: Skein) -> void:
	Extensions.disconnect_all(confirmed)
	confirmed.connect(SignalBus.skein_swapped.emit.bind(old_thread, new_thread))
	confirmed.connect(%PaletteMenu.show)
	confirmed.connect(%SwapThreadMenu.hide)
	show()
