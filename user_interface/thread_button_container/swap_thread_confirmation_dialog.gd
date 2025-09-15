extends ConfirmationDialog

## Setup for confirming the swap from [param old_thread]
## to [param new_thread].[br][br]
## Note: 
## Connecting to [signal ConfirmationDialog.confirmed] instead of awaiting it
## is necessary to prevent a bug where multiple methods wait for one
## emission of this signal, resulting in multiple threads being swapped.
func confirm(old_thread: XStitchThread, new_thread: XStitchThread) -> void:
	Extensions.disconnect_all(confirmed)
	confirmed.connect(%PaletteController.swap_thread_command.bind(old_thread, new_thread))
	confirmed.connect(%PaletteMenu.show)
	confirmed.connect(%SwapThreadMenu.hide)
	show()
