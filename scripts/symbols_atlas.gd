extends Node

const path = "res://assets/svg-symbols/"
const suffix = ".svg"
var symbols: Dictionary[StringName, XStitchSymbol]

func _ready() -> void:
	_load_data()

## Loads vector files from the assets folder.
func _load_data():
	for file in ResourceLoader.list_directory(path):
		if !file.ends_with(suffix):
			continue;
		var s = XStitchSymbol.new();
		s.id = file.trim_suffix(suffix)
		s.symbol_name = file.trim_suffix(suffix)
		s.data = load(path + file)
		symbols.get_or_add(s.get_identifying_name(), s)
	return

## Returns symbol by its global ID.
func get_symbol_by_global_id(id: String) -> XStitchSymbol:
	return symbols.get(id, null)

func assign_symbol() -> XStitchSymbol:
	var unassigned_symbols = symbols.values().filter(func(x): return !x.assigned)
	var symbol = unassigned_symbols[randi() % unassigned_symbols.size()]
	return symbol
