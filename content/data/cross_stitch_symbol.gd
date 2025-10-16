class_name XStitchSymbol
extends Resource

## An SVG symbol that can be assigned to an [XStitchThread]. This is an accessibility
## feature in all cross stitch patterns that lets the user tell different stitches
## apart even on a black-and-white pattern print or in case of color vision disability.

## The ID of this symbol.
@export var id : String

## The name of this symbol, eg. the shape it represents.
@export var symbol_name : String

## The SVG image of the symbol.
@export var data : CompressedTexture2D

## Whether this symbol is already assigned to an [XStitchThread].
var assigned := false

## Constructor.
func _init(p_id := "", p_symbol_name := "", p_load_path := "") -> void:
	id = p_id
	symbol_name = p_symbol_name
	data = load(p_load_path)

## Returns the full unique name for this symbol. (Currently only returns the [member id].)
func get_identifying_name() -> String :
	return id;

## YAML serialization.
func serialize() -> Dictionary:
	return {
		"id": id,
		"symbol_name": symbol_name,
		"load_path": data.load_path
	}

## YAML deserialization.
static func deserialize(data: Variant) -> void:
	if typeof(data) != TYPE_DICTIONARY:
		return YAMLResult.error("Deserializing MyCustomClass expects Dictionary, received %s" % [type_string(typeof(data))])
	
	var dict: Dictionary = data
	
	if !dict.has("id"):
		return YAMLResult.error("Missing id field")
	if !dict.has("symbol_name"):
		return YAMLResult.error("Missing color_name field")
	if !dict.has("load_path"):
		return YAMLResult.error("Missing load_path field")
	
	var p_id: String = dict.get("id")
	var p_symbol_name: String = dict.get("symbol_name")
	var p_load_path: String = dict.get("load_path")
	
	return XStitchSymbol.new(
		p_id,
		p_symbol_name,
		p_load_path
	)
