extends Node

const colors_file := "res://resources/dmc_colors.json"
var skeins: Dictionary

func _ready() -> void:
	_load_data()

func _load_data():
	FileHandler.load_file(FileHandler.Format.FORMAT_JSON, colors_file)
	if FileHandler.get_error() != OK:
		# Fallback
		print_debug("Unable to get file contents: %s" % error_string(FileHandler.get_error()))
		return
	
	var content = FileHandler.get_result()
	
	for entry in content["colors"]:
		var skein = Skein.new()
		skein.brand = str(content["brand"])
		skein.id = str(entry["floss"])
		skein.color_name = str(entry["name"])
		var r = int(entry["r"]) / 255.0
		var g = int(entry["g"]) / 255.0
		var b = int(entry["b"]) / 255.0
		skein.color = Color(r, g, b)
		skeins.get_or_add(skein.get_identifying_name(), skein)

func get_skein_by_global_id(id: String) -> Skein:
	return skeins.get(id, null)
