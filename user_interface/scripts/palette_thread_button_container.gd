extends ThreadButtonContainer

func _ready() -> void:
	pass

func _change_threads() -> void:
	super._change_threads()
	for btn in _created_buttons:
		btn.set_context_menu(%ThreadContextMenu)

func add_thread(thread: XStitchThread):
	threads.append(thread)
	_change_threads()

func select_thread(thread: XStitchThread):
	for btn in _created_buttons:
		if btn.thread == thread:
			btn.set_pressed_no_signal(true)

func remove_thread(thread: XStitchThread):
	threads.erase(thread)
	_change_threads()
