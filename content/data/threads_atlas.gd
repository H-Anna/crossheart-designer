extends Node

## A file that loads data from a [JSON] file and provides [XStitchThread]s
## to other classes.

## Filepath to JSON file.
const FILE := "res://assets/dmc_colors.json"

## Dictionary containing [XStitchThread]s
var threads: Dictionary[String, XStitchThread]

func _ready() -> void:
	_load_data()

## Loads data from the [constant FILE].
func _load_data():
	# Load JSON file
	var json = FileAccess.open(FILE, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open file: ", FileAccess.get_open_error())
		return
	
	var content = JSON.parse_string(json.get_as_text())
	if !content:
		push_error("Failed to parse JSON string.")
		return
	
	# Parse color information
	for entry in content["colors"]:
		var brand = str(content["brand"])
		
		#TODO: this casting will fail if there is ever a non-digit character in this value...
		var id: String = str(int(entry["floss"]))
		
		var color_name = str(entry["name"])
		var r = int(entry["r"]) / 255.0
		var g = int(entry["g"]) / 255.0
		var b = int(entry["b"]) / 255.0
		var color = Color(r, g, b)

		var thread = XStitchThread.new(brand, id, color_name, color)
		# Add thread to dictionary
		threads.get_or_add(thread.get_identifying_name(), thread)

## Returns an array of all loaded threads.
func get_all_threads() -> Array[XStitchThread]:
	return threads.values()

## Returns an [XStitchThread] by its unique ID.
func get_thread_by_global_id(id: String) -> XStitchThread:
	return threads.get(id, null)
