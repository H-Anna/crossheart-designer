extends Node

var _cached_filepath := ""

func _ready() -> void:
	Globals.app = self
	SignalBus.save_requested.connect(_save_to_file)
	SignalBus.load_requested.connect(_load_from_file)

func has_cached_filepath():
	return !_cached_filepath.is_empty()

func _save_to_file(filename: String = _cached_filepath):
	if !$SchemeParser.serialization_enabled:
		SignalBus.toast_notification.emit("Can't save file due to scheme parser failure.")
		return
	
	var state = {}
	state.get_or_add("palette", Globals.palette_controller.palette.serialize())
	state.get_or_add("canvas", Globals.canvas.serialize())
	
	$SchemeParser.data_to_scheme(state)
	var error = $SchemeParser.get_error()
	if error != OK:
		print_debug("Failed to create save data: %s" % error_string(error))
		return
	
	var result = $SchemeParser.get_result()
	FileHandler.save_to_file(FileHandler.Format.FORMAT_JSON, result, filename)
	error = FileHandler.get_error()
	if error != OK:
		print_debug("Failed to save data: %s" % error_string(error))
	_cached_filepath = filename

func _load_from_file(filename: String):
	if !$SchemeParser.serialization_enabled:
		SignalBus.toast_notification.emit("Can't load file due to scheme parser failure.")
		return
		
	FileHandler.load_file(FileHandler.Format.FORMAT_JSON, filename)
	var error = FileHandler.get_error()
	if error != OK:
		print_debug("Failed to load file: %s" % error_string(error))
		return
	
	var result = FileHandler.get_result()
	
	$SchemeParser.data_from_scheme(result)
	error = $SchemeParser.get_error()
	if error != OK:
		print_debug("Failed to load data: %s" % error_string(error))
		return
	
	result = $SchemeParser.get_result()
	
	DisplayServer.window_set_title("Loaded: %s" % filename)
	
	Globals.palette_controller.palette.deserialize(result["palette"])
	Globals.canvas.deserialize(result["canvas"])
	_cached_filepath = filename
	$CommandManager.clear_history()
