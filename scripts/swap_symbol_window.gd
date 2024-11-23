extends Window

@onready var container := $VBoxContainer/ScrollContainer/GridContainer
@onready var search_bar := $VBoxContainer/SearchBar
@onready var no_search_results_label := $NoSearchResultsLabel

@export_file("*.gd") var script_path : String
@export var symbol_picker_ui : PackedScene

var symbol_to_swap : Symbol
var thread_for_symbol : XStitchThread
var swap_callable : Callable

func _ready() -> void:
	_delete_elements()

func set_values(thread: XStitchThread, symbol: Symbol):
	thread_for_symbol = thread
	symbol_to_swap = symbol
	if visible:
		_delete_elements()
		_load_elements(symbol)

func toggle_visibility() -> void:
	visible = !visible

func _load_elements(except: Symbol):
	var symbols = SymbolsAtlas.symbols.values()
	symbols.erase(except)
	var script = load(script_path)
	for symbol in symbols:
		var ui = symbol_picker_ui.instantiate()
		ui.set_script(script)
		container.add_child(ui)
		ui.set_values(symbol, thread_for_symbol.color)
		ui.symbol_selected.connect(_on_symbol_selected)

func _delete_elements():
	for child in container.get_children():
		child.queue_free()

func _on_symbol_selected(new_symbol: Symbol):
	swap_callable.call(thread_for_symbol, symbol_to_swap, new_symbol)
	hide()

func _on_visibility_changed() -> void:
	if visible:
		_load_elements(symbol_to_swap)
	else:
		_delete_elements()

func _on_search_bar_text_changed(new_text: String) -> void:
	new_text = new_text.strip_edges().to_lower()
	var no_results = true
	
	for child in container.get_children():
		if (new_text.is_empty()):
			child.show()
			no_results = false
		else:
			var symbol = child.symbol as Symbol
			var id = symbol.id.to_lower()
			var color_name = symbol.symbol_name.to_lower()
			if id.contains(new_text) or color_name.contains(new_text):
				child.show()
				no_results = false
			else:
				child.hide()
	
	if no_results:
		no_search_results_label.show()
	else:
		no_search_results_label.hide()
