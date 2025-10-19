class_name XStitchThread
extends Resource

## Represents a cross stitch thread with a color and an assigned symbol.

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
	if typeof(data) != TYPE_DICTIONARY:
		return YAMLResult.error("Deserializing XStitchThread expects Dictionary, received %s" % [type_string(typeof(data))])
	
	var dict: Dictionary = data
	
	var p_brand: String = dict.get("brand", "ERROR")
	var p_id: String = str(dict.get("id", "000"))
	var p_color_name: String = dict.get("color_name", "NONE")
	var p_color: Color = dict.get("color", Color.BLACK)
	var p_symbol_id: String = dict.get("symbol_id", "N/A")
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
