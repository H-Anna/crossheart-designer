extends Node

## Manages file saving and loading.

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
	var result = YAML.load_file(filename)
	
	if result.has_error():
		push_error(result.get_error())
	else:
		var data = result.get_data()
		Globals.palette_controller.deserialize(data.get("palette"))
		Globals.canvas.deserialize(data.get("canvas"))
	
	$CommandManager.clear_history()
