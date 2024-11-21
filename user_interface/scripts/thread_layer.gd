class_name ThreadLayer
extends Resource

## A resource that holds drawing layer data.

## The unique ID of the layer.
var id : String = Extensions.generate_unique_string(Extensions.layer_name_length)
var display_name : String = "New Layer"
var visible : bool = true
var locked : bool = false
var active : bool = false
var master_layer : XStitchMasterLayer

func serialize() -> Dictionary:
	var data: Dictionary
	data.get_or_add("id", id)
	data.get_or_add("display_name", display_name)
	data.get_or_add("visible", visible)
	data.get_or_add("locked", locked)
	data.get_or_add("active", active)
	return data

func deserialize(data: Dictionary) -> void:
	pass
