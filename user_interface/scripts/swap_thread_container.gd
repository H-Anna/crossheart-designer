extends ThreadButtonContainer

func on_thread_button_clicked(button: ThreadButton):
	SignalBus.skein_swap_requested.emit(button.thread)
