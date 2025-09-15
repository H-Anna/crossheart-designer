class_name DataConverter
extends Resource
## Converts data to specific formats and vice versa.

var _result : Variant

func get_result():
	return _result

func to_json_string(data: Dictionary) -> Error:
	_result = JSON.stringify(data, "\t", false)
	return OK

func from_json_string(json_string: String) -> Error:
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
			print_debug("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			_result = null
			return ERR_PARSE_ERROR
	_result = json.get_data()
	return OK
