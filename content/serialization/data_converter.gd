class_name DataConverter
extends Resource

## Converts data to specific formats and vice versa.

## The result of the conversion.
var _result : Variant

## Returns the result.
func get_result():
	return _result

## Converts a dictionary to [JSON] string. Returns [enum Error.OK] on success.
func to_json_string(data: Dictionary) -> Error:
	_result = JSON.stringify(data, "\t", false)
	return OK

## Converts a [JSON] string to [Variant] data. returns [enum Error.OK] on success. 
func from_json_string(json_string: String) -> Error:
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if parse_result != OK:
			print_debug("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			_result = null
			return ERR_PARSE_ERROR
	_result = json.get_data()
	return OK
