extends Node

## High-level API to load files in specific formats

enum Format { FORMAT_BINARY, FORMAT_JSON, FORMAT_XML, FORMAT_OXS }

## Converts data to specific formats and vice versa.
@onready var data_converter := DataConverter.new()
## Stores last error
var _error : Error = OK
var _result : Variant

func get_error():
	return _error

func get_result():
	return _result

func save_to_file(format: Format, data: Variant, filename: String) -> void:
	# Attempt to open file
	var save_file = FileAccess.open(filename, FileAccess.WRITE)
	_error = FileAccess.get_open_error()
	if _error != OK:
		return
	
	# Convert data to one of these formats
	var saved_string : String
	
	match format:
		Format.FORMAT_JSON:
			_error = data_converter.to_json_string(data)
			saved_string = data_converter.get_result()
		_:
			_error = ERR_UNCONFIGURED
			return
	
	if _error != OK:
		print_debug("Unable to convert data to save file, error: %s" % error_string(_error))
		return
	
	save_file.store_line(saved_string)


func load_file(format: Format, filename: String) -> void:
	# If file doesn't exist, stop
	if not FileAccess.file_exists(filename):
		#print_debug("Error! We don't have a save to load.")
		_error = ERR_FILE_NOT_FOUND
		return
	
	# Attempt to open file
	var save_file = FileAccess.open(filename, FileAccess.READ)
	_error = FileAccess.get_open_error()
	if _error != OK:
		return
	
	var content = save_file.get_as_text()
	
	match format:
		Format.FORMAT_JSON:
			_error = data_converter.from_json_string(content)
			_result = data_converter.get_result()
		_:
			_error = ERR_UNCONFIGURED
	
	if _error != OK:
		print_debug("Unable to load file, error: %s" % error_string(_error))
