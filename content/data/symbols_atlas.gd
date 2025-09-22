extends Node

## A file that loads SVG symbols from a folder and provides [XStitchSymbol]s to
## other classes.

## The file system path to load SVG symbols from.
const PATH = "res://assets/svg-symbols/"

## The suffix used by the files we want to load.
const SUFFIX = ".svg"

## A dictionary of [XStitchSymbol]s. The keys are the global/unique symbol IDs
## for fast retrieval.
var symbols: Dictionary[StringName, XStitchSymbol]


func _ready() -> void:
	load_files()

## Loads vector files from the assets folder.
func load_files() -> void:
	for file in ResourceLoader.list_directory(PATH):
		if !file.ends_with(SUFFIX):
			continue;
		var s = XStitchSymbol.new();
		s.id = file.trim_suffix(SUFFIX)
		s.symbol_name = file.trim_suffix(SUFFIX)
		s.data = load(PATH + file)
		symbols.get_or_add(s.get_identifying_name(), s)
	return

## @experimental: This method is unused.
## Returns symbol by its global ID.
func get_symbol_by_global_id(id: String) -> XStitchSymbol:
	return symbols.get(id, null)

## Returns a random symbol that is unassigned.
func get_unassigned_symbol() -> XStitchSymbol:
	var unassigned_symbols = symbols.values().filter(func(x): return !x.assigned)
	var symbol = unassigned_symbols[randi() % unassigned_symbols.size()]
	return symbol
