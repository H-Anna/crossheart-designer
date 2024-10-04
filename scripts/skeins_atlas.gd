extends Node

var skeins: Dictionary
var resources_folder := "res://resources/"

func _ready() -> void:
	_load_skeins()

func _load_skeins():
	var resources = DirAccess.get_files_at(resources_folder)
	for res in resources:
		var skein = load(resources_folder + res) as Skein
		skeins.get_or_add(skein.get_identifying_name(), skein)

func get_skein_by_global_id(id: String) -> Skein:
	if id in skeins:
		return skeins[id]
	return null
