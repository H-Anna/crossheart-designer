extends ConfirmationDialog

## Setup for confirming a [param thread]'s
## deletion from the palette.[br][br]
## Note: 
## Connecting to [signal ConfirmationDialog.confirmed] instead of awaiting it
## is necessary to prevent a bug where multiple methods wait for one
## emission of this signal, resulting in multiple threads being deleted.
func confirm(thread: XStitchThread) -> void:
	Extensions.disconnect_all(confirmed)
	confirmed.connect(SignalBus.thread_removed_from_palette.emit.bind(thread))
	show()
