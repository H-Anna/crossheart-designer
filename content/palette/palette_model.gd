class_name PaletteModel
extends Resource

## Holds data related to the [XStitchThread]s added to the
## pattern.

## The array of threads present in the palette.
@export var threads : Array[XStitchThread]

## The index of the selected thread.
var selected : int = -1

## Constructor.
func _init(p_threads : Array[XStitchThread] = []) -> void:
	threads = p_threads


## YAML serialization.
func serialize() -> Dictionary:
	return { 
		"threads": threads
	}

## YAML deserialization.
static func deserialize(data: Variant):
	if typeof(data) != TYPE_DICTIONARY:
		return YAMLResult.error("Deserializing MyCustomClass expects Dictionary, received %s" % [type_string(typeof(data))])
	var dict: Dictionary = data
	
	#TODO: wait for engine and addon update to remove this workaround...
	var array: Array = dict.get("threads", [])
	var p_threads: Array[XStitchThread]
	p_threads.append_array(array)
	
	return PaletteModel.new(p_threads)
