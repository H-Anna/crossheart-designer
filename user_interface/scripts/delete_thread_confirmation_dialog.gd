extends ConfirmationDialog

func confirm(thread: Skein) -> void:
	Extensions.disconnect_all(confirmed)
	confirmed.connect(SignalBus.skein_removed_from_palette.emit.bind(thread))
	show()
