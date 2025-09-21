extends ThreadButtonContainer

func _ready() -> void:
	pass

func create_thread_button(thread: XStitchThread) -> ThreadButton:
	var btn = super.create_thread_button(thread)
	btn.set_context_menu(%ThreadContextMenu)
	return btn

func add_thread(thread: XStitchThread):
	threads.append(thread)
	reset_buttons()

func select_thread(thread: XStitchThread):
	for btn in _created_buttons:
		if btn.thread == thread:
			btn.set_pressed_no_signal(true)

func remove_thread(thread: XStitchThread):
	threads.erase(thread)
	reset_buttons()
