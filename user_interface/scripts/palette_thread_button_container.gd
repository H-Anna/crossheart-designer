extends ThreadButtonContainer

var _selected_thread: Skein

func _ready() -> void:
	SignalBus.palette_ui_changed.connect(on_palette_ui_changed)

func _change_threads() -> void:
	super._change_threads()
	for btn in _created_buttons:
		btn.set_context_menu(%SkeinPopupMenu)
		if btn.thread == _selected_thread:
			btn.set_pressed_no_signal(true)

func on_palette_ui_changed(palette: Palette):
	_selected_thread = palette.selected_thread
	threads = palette.colors

func on_thread_button_clicked(button: ThreadButton):
	_selected_thread = button.thread
	SignalBus.skein_selected.emit(_selected_thread)
	print("Thread selected: %s" % _selected_thread.get_identifying_name())
