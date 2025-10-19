class_name XStitchThread
extends Resource

## Represents a cross stitch thread with a color and an assigned symbol.

#region Serialization schema
## Serialization schema.
const _schema: String = """
type: object
properties:
	brand:
		type: string
		minimum: 2
	id:
		type: string
		minimum: 2
	global_id:
		type: string
	color_name:
		type: string
	color:
		type: object
		x-yaml-tag: Color
	symbol_id:
		type: string
		minimum: 2
required:
- brand
- id
- color_name
- color
"""
#endregion

## The thread brand.
@export var brand : String

## The thread ID, given by the manufacturer.
@export var id : String

## The name of the color, given by the manufacturer.
@export var color_name : String

## The RGB color of the thread.
@export var color : Color = Color.MAGENTA

## The [XStitchSymbol] assigned to this thread.
var symbol : XStitchSymbol:
	set = set_symbol

## Constructor.
func _init(p_brand := "", p_id := "", p_color_name := "", p_color := Color.WHITE, p_symbol: XStitchSymbol = null) -> void:
	brand = p_brand
	id = p_id
	color_name = p_color_name
	color = p_color
	symbol = p_symbol

## Returns the full unique name for this thread, eg. "DMC310".
func get_identifying_name() -> String:
	return brand + id;

## When setting the symbol for this thread, marks the old symbol as unassigned
## and the new symbol as assigned.
func set_symbol(value: XStitchSymbol) -> void:
	if symbol != null:
		symbol.assigned = false
	
	if value != null:
		value.assigned = true
	symbol = value

#region Serialization
## YAML serialization.
func serialize() -> Dictionary:
	return {
		"brand": brand,
		"id": str(id),
		"global_id": get_identifying_name(),
		"color_name": color_name,
		"color": color,
		"symbol_id": symbol.get_identifying_name()
	}

## YAML deserialization.
static func deserialize(data: Variant):
	var schema = YAML.load_schema_from_string(_schema)
	if !schema:
		push_error("Failed to parse schema!")
		return
	
	#var string_data = data as String
	var result = YAML.parse_and_validate(data, schema)
	
	if result.has_error():
		push_error("Parse error: %s" % result.get_error())
		return
	
	if result.has_validation_errors():
		push_error(result.get_validation_summary())
		return
	
	var thread_data = result.get_data()
	print(thread_data.color_name)
	return
	
	
	if typeof(data) != TYPE_DICTIONARY:
		return YAMLResult.error("Deserializing MyCustomClass expects Dictionary, received %s" % [type_string(typeof(data))])
	
	var dict: Dictionary = data
	
	if !dict.has("brand"):
		return YAMLResult.error("Missing brand field")
	if !dict.has("id"):
		return YAMLResult.error("Missing id field")
	if !dict.has("color_name"):
		return YAMLResult.error("Missing color_name field")
	if !dict.has("color"):
		return YAMLResult.error("Missing color field")
	if !dict.has("symbol_id"):
		return YAMLResult.error("Missing symbol_id field")
	
	var p_brand: String = dict.get("brand")
	var p_id: String = str(dict.get("id")) #TODO: remove this workaround once addon gets updated
	var p_color_name: String = dict.get("color_name")
	var p_color: Color = dict.get("color")
	var p_symbol_id: String = dict.get("symbol_id")
	var p_symbol := SymbolsAtlas.get_symbol_by_global_id(p_symbol_id)
	
	return XStitchThread.new(
		p_brand,
		p_id,
		p_color_name,
		p_color,
		p_symbol
	)
#endregion

func _to_string() -> String:
	return get_identifying_name()
