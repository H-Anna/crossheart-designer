extends ConfirmationDialog

func confirm(old_thread: Skein, new_thread: Skein) -> void:
	Extensions.disconnect_all(confirmed)
	confirmed.connect(SignalBus.skein_swapped.emit.bind(old_thread, new_thread))
	confirmed.connect(%PaletteMenu.show)
	confirmed.connect(%SwapThreadMenu.hide)
	show()
