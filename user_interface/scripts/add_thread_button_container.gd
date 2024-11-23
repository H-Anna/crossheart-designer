extends ThreadButtonContainer

func on_thread_button_clicked(button: ThreadButton):
	SignalBus.thread_added_to_palette.emit(button.thread)
	print("Add thread: %s" % button.thread.get_identifying_name())
	%AddThreadMenu.hide()
	%PaletteMenu.show()
