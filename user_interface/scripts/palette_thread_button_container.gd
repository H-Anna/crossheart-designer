extends ThreadButtonContainer

func _ready() -> void:
	SignalBus.palette_ui_changed.connect(on_palette_ui_changed)

func _change_threads() -> void:
	super._change_threads()
	for btn in _created_buttons:
		btn.set_context_menu(%SkeinPopupMenu)

func on_palette_ui_changed(palette: Palette):
	threads = palette.colors

func on_thread_button_clicked(button: ThreadButton):
	SignalBus.skein_selected.emit(button.thread)
	print("Thread selected: %s" % button.thread.get_identifying_name())
