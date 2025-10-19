extends Node

## Manages file saving and loading.

const _schema_path := "res://schemes/schema.yaml"

## Cached file path for quick saving.
var _cached_filepath := ""

## Registers custom classes with YAML addon.
func _enter_tree() -> void:
	YAML.register_class(XStitchThread)
	YAML.register_class(PaletteModel)

## Adds self to globals. Connects signals.
func _ready() -> void:
	Globals.app = self
	SignalBus.save_requested.connect(_save_to_file)
	SignalBus.load_requested.connect(_load_from_file)


func has_cached_filepath():
	return !_cached_filepath.is_empty()

#TODO: GDSchema validation!!
func _save_to_file(filename: String = _cached_filepath) -> void:
	var data = {
		"palette": Globals.palette_controller.serialize(),
		"canvas": Globals.canvas.serialize()
	}
	var result = YAML.save_file(data, filename)
	if result.has_error():
		push_error("Unable to save YAML file: ", result.get_error())
	else:
		print("Saved to: ", filename)

func _load_from_file(filename: String):
	var save_file = FileAccess.open(filename, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open file at: %s" % filename)
		return
	
	var save_content = save_file.get_as_text()
	
	var schema_file = FileAccess.open(_schema_path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open file at: %s" % filename)
		return
	
	var schema_content = schema_file.get_as_text()
	
	var schema = YAML.load_schema_from_string(schema_content)
	if !schema:
		push_error("Failed to parse schema!")
		return
	
	var result = YAML.parse_and_validate(save_content, schema)
	var data = result.get_data()
	print(data)
	
	$CommandManager.clear_history()
	return
	
	
	
	#var result = YAML.load_file(filename)
	#
	#if result.has_error():
		#push_error(result.get_error())
	#else:
		#var data = result.get_data()
		#Globals.palette_controller.deserialize(data.get("palette"))
		#Globals.canvas.deserialize(data.get("canvas"))
	#
	#$CommandManager.clear_history()
