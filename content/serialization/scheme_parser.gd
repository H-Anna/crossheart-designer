class_name SchemeParser
extends Node

@export_file var latest_scheme_path : String
@export_file var scheme_path : String
var scheme : Dictionary
var content : Dictionary
var serialization_enabled := true

var _result : Variant
var _error : Error = OK

func get_result():
	return _result

func get_error():
	return _error

# TODO: disable saving and loading
func _ready() -> void:
	load_scheme()
	if _error != OK:
		print_debug("Failed to load scheme: %s\nSaving and loading will be disabled." % error_string(_error))
		serialization_enabled = false
	#SignalBus.scheme_parser_ready.emit(self, get_empty_content())

# TODO: apply versioning
func load_scheme() -> void:
	FileHandler.load_file(FileHandler.Format.FORMAT_JSON, scheme_path)
	var error = FileHandler.get_error()
	if error != OK:
		print_debug("Scheme load failed: %s" % error_string(error))
		return
	scheme = FileHandler.get_result()
	if !scheme.has("content"):
		print_debug("Content has not been defined for this scheme.")
		_error = ERR_DOES_NOT_EXIST
		return
	content = scheme.get("content")

func get_empty_content() -> Dictionary:
	return _construct_scheme(content)

func _construct_scheme(subset: Dictionary) -> Dictionary:
	var res = {}
	for key in subset:
		res.get_or_add(key)
		
		match typeof(subset[key]):
			TYPE_DICTIONARY:
				res[key] = _construct_scheme(subset[key])
			TYPE_ARRAY:
				var arr = []
				#for elem in subset[key]:
				#	arr.append(_construct_scheme(elem))
				res[key] = arr
			TYPE_STRING:
				if subset[key].begins_with("28:"):
					res[key] = []	# Trust me bro levels of type safety
				else:
					res[key] = type_convert(null, _get_scheme_type(subset[key]))
			var invalid_type: # This shouldn't happen.
				res[key] = null
				print_debug("Invalid type: %s" % type_string(invalid_type))
	return res

func data_to_scheme(data: Dictionary):
	if _validate_against_content(data, content):
		_result = _convert_to_scheme(data)
	else:
		print_debug("Data to scheme conversion failed: %s" % error_string(_error))

func data_from_scheme(schemed_data: Dictionary):
	if _validate_loaded_scheme(schemed_data):
		_result = _convert_to_data(schemed_data["content"], content)
	else:
		print_debug("Scheme to data conversion failed: %s" % error_string(_error))

func _validate_against_content(data: Dictionary, against: Dictionary) -> bool:
	# If keys aren't equal, data is invalid.
	if data.keys() != against.keys():
		print_debug("Keys mismatch.\nExpected: %s\nActual: %s" % [against.keys(), data.keys()])
		_error = ERR_INVALID_DATA
		return false
	
	# Iterate over scheme keys.
	for key in against:
		# If a key is missing, the data is invalid.
		if !data.has(key):
			print_debug("Key '%s' missing from data." % key)
			_error = ERR_INVALID_DATA
			return false
		
		# Check type of value.
		match typeof(against[key]):
			TYPE_DICTIONARY: # Recursive comparison of nested dictionaries.
				return _validate_type(data[key], against[key]) && _validate_against_content(data[key], against[key])
			TYPE_ARRAY: # Scheme should have only one element in each array to validate against.
				if !_validate_type(data[key], against[key]):
					return false
				for elem in data[key]:
					return _validate_against_content(elem, against[key].front())
			TYPE_STRING: # All other elements should be strings that describe type.
					# Complex types
					if against[key].begins_with("28:"):
						var t = against[key].trim_prefix("28:")
						return data[key].all(func(d) -> bool: return _validate_scheme_type(d, t))
					# Simple types
					else:
						return _validate_scheme_type(data[key], against[key])
			var invalid_type: # This shouldn't happen.
				print_debug("Data type '%s' in scheme invalid." % type_string(invalid_type))
				_error = ERR_INVALID_DATA
				return false
	
	_error = OK
	return true

func _validate_type(data, against) -> bool:
	var data_type = typeof(data)
	var against_type = typeof(against)
	if data_type != against_type:
			print_debug("Data type '%s' does not match type '%s'." % [type_string(data_type), type_string(against_type)])
			_error = ERR_INVALID_DATA
			return false
	return true

func _validate_scheme_type(data: Variant, against_type: String) -> bool:
	return typeof(data) == _get_scheme_type(against_type)

func _get_scheme_type(number: String) -> int:
	if !number.is_valid_int():
		print_debug("'%s' is not a valid integer." % number)
		_error = ERR_INVALID_DATA
		return TYPE_MAX
	
	var res = number.to_int()
	if res < 0 || res >= TYPE_MAX:
		print_debug("'%s' is not a valid type." % number)
		_error = ERR_INVALID_DATA
		return TYPE_MAX
	
	_error = OK
	return res

func _convert_to_scheme(data: Dictionary):
	var res = {}
	for key in scheme:
		if key == "content":
			res.get_or_add(key, data)
		else:
			res.get_or_add(key, scheme[key])
	return res

##TODO: refactor this
func _validate_loaded_scheme(loaded: Dictionary) -> bool:
	## Scheme keys mismatch. Eg. scheme hasn't been stamped
	if loaded.keys() != scheme.keys():
		print_debug("Keys mismatch.\nExpected: %s\nActual: %s" % [scheme.keys(), loaded.keys()])
		_error = ERR_INVALID_DATA
		return false
	
	## Scheme version mismatch means the save data may not be able to be loaded
	var vs = scheme["version"]
	var vl = loaded["version"]
	
	if vs != vl:
		var higher = Extensions.higher_version(vs, vl)
		if higher == vl:
			pass # TODO: higher versions can't be loaded
			print_debug("Version number mismatch.\nExpected: %s\nActual (in loaded file): %s" % [vs, vl])
			_error = ERR_CANT_RESOLVE
			return false
		else: ## Minor versions are backward compatible
			pass # TODO: enable minor version compatibility
	
	return true

func _convert_to_data(schemed_data: Dictionary, content_types: Dictionary) -> Dictionary:
	var res = {}
	for key in schemed_data:
		match typeof(content_types[key]):
			TYPE_DICTIONARY:
				res[key] = _convert_to_data(schemed_data[key], content_types[key])
			TYPE_ARRAY:
				var arr = []
				for elem in schemed_data[key]:
					arr.append(_convert_to_data(elem, content_types[key].front()))
				res[key] = arr
			_:
				if content_types[key].begins_with("28:"):
					var type = _get_scheme_type(content_types[key].trim_prefix("28:"))
					var arr = []
					for elem in schemed_data[key]:
						arr.append(_from_string_to_data(type, elem))
					res[key] = arr
				else:
					var type = _get_scheme_type(content_types[key])
					res[key] = _from_string_to_data(type, schemed_data[key])
	return res

func _from_string_to_data(type: int, from):
	match type:
		TYPE_VECTOR2I:
			var vec = from.trim_prefix("(").trim_suffix(")").split(", ")
			return Vector2i(vec[0].to_int(), vec[1].to_int())
		_:
			return from
