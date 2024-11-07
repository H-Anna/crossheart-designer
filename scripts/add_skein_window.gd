extends Window

@onready var container := $VBoxContainer/ScrollContainer/FlowContainer
@onready var search_bar := $VBoxContainer/SearchBar
@onready var all_colors_added_label := $AllColorsAddedLabel
@onready var no_search_results_label := $NoSearchResultsLabel

@export_file("*.gd") var script_path : String
@export var palette : Palette
@export var skein_picker_ui : PackedScene

func _ready() -> void:
	_delete_elements()

func toggle_visibility() -> void:
	visible = !visible

func _load_elements(except: Array):
	var skeins = SkeinsAtlas.skeins.values()
	if except == skeins:
		all_colors_added_label.show()
	else:
		all_colors_added_label.hide()
		var script = load(script_path)
		for skein in skeins:
			if skein not in except:
				var ui = skein_picker_ui.instantiate()
				ui.set_script(script)
				container.add_child(ui)
				ui.set_values(skein)
				ui.skein_selected.connect(_on_skein_selected)

func _on_skein_selected(skein: Skein):
	SignalBus.skein_added_to_palette.emit(skein)
	hide()

func _delete_elements():
	for child in container.get_children():
		child.queue_free()

func _on_visibility_changed() -> void:
	if visible:
		_load_elements(palette.colors)
	else:
		search_bar.text = ""
		_delete_elements()

func _on_search_bar_text_changed(new_text: String) -> void:
	new_text = new_text.strip_edges().to_lower()
	var no_results = true
	
	for child in container.get_children():
		if (new_text.is_empty()):
			child.show()
			no_results = false
		else:
			var skein = child.skein as Skein
			var id = skein.id.to_lower()
			var color_name = skein.color_name.to_lower()
			if id.contains(new_text) or color_name.contains(new_text):
				child.show()
				no_results = false
			else:
				child.hide()
	
	if no_results:
		no_search_results_label.show()
	else:
		no_search_results_label.hide()
