extends Window

@onready var canvas : Canvas = $Canvas
@onready var palette : Palette = $Palette

func _ready() -> void:
	SignalBus.new_canvas_opened.connect(create_new_canvas)
	SignalBus.new_canvas_opened.connect(create_new_palette)
	SignalBus.save_menu_opened.connect(save_dialog)
	SignalBus.load_menu_opened.connect(load_dialog)
	DisplayServer.window_set_title("Unsaved Canvas* - CrossStitch Prototype")
	
	create_new_palette()
	create_new_canvas(Rect2i(0, 0, 100, 100))
	AppSnapshotManager.clear_history()
	
	grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_undo"):
		SignalBus.undo_pressed.emit()
	elif event.is_action_pressed("ui_redo"):
		SignalBus.redo_pressed.emit()
	elif event.is_action_pressed("debug_clear_history"):
		AppSnapshotManager.clear_history()
		print_debug("DEBUG: History cleared")

func create_new_canvas(rect: Rect2i):
	$CanvasInterface.show()
	canvas.show()
	canvas.create_canvas(rect)

func create_new_palette():
	palette.clear()

func save_dialog():
	$SaveFileDialog.show()

func save_file_selected(path: String):
	SignalBus.save_requested.emit(path)

func load_dialog():
	$LoadFileDialog.show()

func load_file_selected(path: String):
	SignalBus.load_requested.emit(path)

func _on_app_window_focus_entered() -> void:
	SignalBus.focus_changed.emit(Helpers.MouseFocusMode.DRAWING_AREA)

func _on_preview_window_focus_entered() -> void:
	SignalBus.focus_changed.emit(Helpers.MouseFocusMode.PREVIEW_WINDOW)

func _on_layers_window_focus_entered() -> void:
	SignalBus.focus_changed.emit(Helpers.MouseFocusMode.LAYERS_WINDOW)
