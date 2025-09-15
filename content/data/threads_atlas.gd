extends Node

const colors_file := "res://assets/dmc_colors.json"
var threads: Dictionary

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
		var thread = XStitchThread.new()
		thread.brand = str(content["brand"])
		thread.id = str(entry["floss"])
		thread.color_name = str(entry["name"])
		var r = int(entry["r"]) / 255.0
		var g = int(entry["g"]) / 255.0
		var b = int(entry["b"]) / 255.0
		thread.color = Color(r, g, b)
		threads.get_or_add(thread.get_identifying_name(), thread)

func get_all_threads() -> Array[XStitchThread]:
	var arr: Array[XStitchThread]
	for s in threads.values():
		arr.append(s)
	return arr

func get_thread_by_global_id(id: String) -> XStitchThread:
	return threads.get(id, null)
