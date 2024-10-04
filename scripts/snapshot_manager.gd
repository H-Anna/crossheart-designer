class_name SnapshotManager
extends Node

@export_range(1, 100) var history_size : int = 10
# A history of snapshots. The last snapshot is always the current one.
var snapshot_history : Array[Snapshot]
var history_index := 0

var scheme_parser : SchemeParser
#var empty_state : Dictionary

# Get-only property for the current snapshot
var current_snapshot : Snapshot :
	get:
		if snapshot_history.is_empty():
			return null
		return snapshot_history[history_index]

func _ready() -> void:
	SignalBus.scheme_parser_ready.connect(initialize)
	SignalBus.save_requested.connect(save_to_file)
	SignalBus.load_requested.connect(load_from_file)
	
	SignalBus.palette_changed.connect(store_palette)
	SignalBus.canvas_changed.connect(store_canvas)
	SignalBus.canvas_resized.connect(store_canvas)
	
	SignalBus.layer_changed.connect(store_layer)
	SignalBus.layer_added.connect(store_layer)
	SignalBus.layer_removed.connect(drop_layer)
	
	SignalBus.undo_pressed.connect(roll_back)
	SignalBus.redo_pressed.connect(roll_forward)

func initialize(_parser: SchemeParser, _content: Dictionary):
	scheme_parser = _parser
	#empty_state = _content
	
	var snap = Snapshot.new()
	snap.state = _content
	snapshot_history.append(snap)

func create_snapshot():
	# Drop all snapshots ahead of current snapshot to keep history linear
	if history_index != snapshot_history.size() - 1:
		snapshot_history.resize(history_index + 1)
	# Create new snapshot
	snapshot_history.append(current_snapshot.deep_copy())
	history_index += 1
	SignalBus.snapshot_created.emit(current_snapshot)

func clear_history(keep_current: bool = true):
	var snapshot = current_snapshot.deep_copy()
	snapshot_history.clear()
	snapshot_history.append(snapshot)
	history_index = 0

func roll_back():
	# Can't roll back if history is empty
	if snapshot_history.is_empty():
		return
	
	# Clamp history index to prevent index out of range error
	history_index = clamp(history_index - 1, 0, snapshot_history.size() - 1)
	SignalBus.current_snapshot_changed.emit(current_snapshot)

func roll_forward():
	# Can't roll forward if history is empty
	if snapshot_history.is_empty():
		return
	
	# Clamp history index to prevent index out of range error
	history_index = clamp(history_index + 1, 0, snapshot_history.size() - 1)
	SignalBus.current_snapshot_changed.emit(current_snapshot)

func store_data(data: Dictionary, new_snapshot: bool = true):
	if new_snapshot:
		create_snapshot()
	current_snapshot.store_data(data)

func store_palette(palette: Palette, new_snapshot: bool = true):
	if new_snapshot:
		create_snapshot()
	current_snapshot.store_palette(palette)

func store_canvas(canvas: Canvas, new_snapshot: bool = true):
	if new_snapshot:
		create_snapshot()
	current_snapshot.store_canvas(canvas)

func store_layer(layer: TileMapLayer, new_snapshot: bool = true):
	if new_snapshot:
		create_snapshot()
	current_snapshot.store_layer(layer)

func drop_layer(layer: TileMapLayer, new_snapshot: bool = true):
	if new_snapshot:
		create_snapshot()
	current_snapshot.drop_layer(layer)

func save_to_file(filename: String):
	scheme_parser.data_to_scheme(current_snapshot.state)
	var error = scheme_parser.get_error()
	if error != OK:
		print_debug("Failed to create save data: %s" % error_string(error))
		return
	
	var result = scheme_parser.get_result()
	FileHandler.save_to_file(FileHandler.Format.FORMAT_JSON, result, filename)
	error = FileHandler.get_error()
	if error != OK:
		print_debug("Failed to save data: %s" % error_string(error))

func load_from_file(filename: String):
	FileHandler.load_file(FileHandler.Format.FORMAT_JSON, filename)
	var error = FileHandler.get_error()
	if error != OK:
		print_debug("Failed to load file: %s" % error_string(error))
		return
	
	var result = FileHandler.get_result()
	
	scheme_parser.data_from_scheme(result)
	error = scheme_parser.get_error()
	if error != OK:
		print_debug("Failed to load data: %s" % error_string(error))
		return
	
	result = scheme_parser.get_result()
	store_data(result)
	clear_history()
	
	SignalBus.current_snapshot_changed.emit(current_snapshot)
	DisplayServer.window_set_title("%s* - CrossStitch Prototype" % filename)
