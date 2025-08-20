extends Node

const path = "res://assets/svg-symbols/"
const suffix = ".svg"
var symbols: Dictionary

func _ready() -> void:
	_load_data()

func _load_data():
	print_debug(DirAccess.get_files_at(path))
	
	for file in DirAccess.get_files_at(path):
		if !file.ends_with(suffix):
			continue;
		var s = Symbol.new();
		s.id = file.trim_suffix(suffix)
		s.symbol_name = file.trim_suffix(suffix)
		s.data = load(path + file)
		symbols.get_or_add(s.get_identifying_name(), s)
	return

func get_symbol_by_global_id(id: String) -> Symbol:
	return symbols.get(id, null)

func get_random_symbol() -> Symbol:
	print_debug("Modulo by ", symbols.size())
	return symbols.values()[randi() % symbols.size()]
