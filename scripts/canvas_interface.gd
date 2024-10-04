extends CanvasLayer

const FILE_OPEN = 2
const FILE_SAVE = 1
const FILE_NEWCANVAS = 3
const FILE_EXPORT = 4

func _on_file_id_pressed(id: int) -> void:
	match id:
		FILE_OPEN: SignalBus.load_menu_opened.emit()
		FILE_SAVE: SignalBus.save_menu_opened.emit()
		FILE_EXPORT: print_debug("Export doesn't work yet.")
		FILE_NEWCANVAS: SignalBus.new_canvas_opened.emit(Rect2i(0, 0, 100, 100))
		_: pass


func _on_canvas_id_pressed(id: int) -> void:
	match id:
		0: print_debug("Resize doesn't work yet.")
		1: print_debug("Clear canvas doesn't work yet.")
		2: print_debug("Change cloth color doesn't work yet.")
		_: pass


func _on_layers_id_pressed(id: int) -> void:
	match id:
		0: print_debug("Add layer doesn't work yet.")
		1: print_debug("Remove layer doesn't work yet.")
		_: pass
