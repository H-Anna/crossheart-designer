extends PopupMenu

const OPEN = 0
const SAVE = 1
const SAVE_AS = 2
const EXPORT = 3

var _save_as := false

func _on_index_pressed(index: int) -> void:
	match index:
		OPEN:
			%LoadFileDialog.show()
		SAVE:
			if Globals.app.has_cached_filepath():
				SignalBus.save_requested.emit()
			else:
				%SaveFileDialog.show()
		SAVE_AS:
			%SaveFileDialog.show()
		_:
			SignalBus.toast_notification.emit("This feature is in progress, thank you for your patience!")

func _on_load_file_dialog_file_selected(path: String) -> void:
	SignalBus.load_requested.emit(path)


func _on_save_file_dialog_file_selected(path: String) -> void:
	SignalBus.save_requested.emit(path)
