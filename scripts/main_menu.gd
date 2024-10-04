extends CanvasLayer

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit() # default behavior


func _on_quit_btn_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)


func _on_load_file_btn_pressed() -> void:
	SignalBus.load_requested.emit()


func _on_new_canvas_btn_pressed() -> void:
	SignalBus.new_canvas_opened.emit(Rect2i(0, 0, 100, 100))
