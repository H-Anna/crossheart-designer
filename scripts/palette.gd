class_name Palette
extends Node

@export var colors : Array[Skein]
var selected_idx : int = -1

func _ready() -> void:
	SignalBus.skein_added_to_palette.connect(add_skein)
	SignalBus.skein_removed_from_palette.connect(remove_skein)
	SignalBus.skein_swapped.connect(swap_skein)
	SignalBus.skein_selected.connect(select_skein)
	SignalBus.current_snapshot_changed.connect(deserialize)

func clear():
	colors.clear()
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func serialize() -> Array:
	var arr : Array[Dictionary]
	for skein in colors:
		var elem : Dictionary
		elem.get_or_add("brand", skein.brand)
		elem.get_or_add("id", skein.id)
		elem.get_or_add("global_id", skein.get_identifying_name())
		elem.get_or_add("color_name", skein.color_name)
		elem.get_or_add("color_hex", skein.color.to_html(false))
		arr.append(elem)
	return arr

func deserialize(snapshot: Snapshot):
	colors.clear()
	var data = snapshot.state["palette"] as Array
	for dict in data:
		colors.append(SkeinsAtlas.get_skein_by_global_id(dict["global_id"]))
	SignalBus.palette_ui_changed.emit(self)

func add_skein(skein: Skein):
	colors.append(skein)
	if selected_idx == -1:
		select_skein(skein)
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func remove_skein(skein: Skein):
	var idx = colors.find(skein)
	colors.erase(skein)
	if idx == selected_idx:
		if colors.size() == 0:
			selected_idx = -1
		else:
			selected_idx = clamp(selected_idx, 0, colors.size())
		
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func select_skein(skein: Skein):
	selected_idx = colors.find(skein)

func get_selected_skein():
	if colors.is_empty():
		return null
	# Fallback
	if selected_idx < 0 || selected_idx >= colors.size():
		selected_idx = 0
	return colors[selected_idx]

func swap_skein(old_skein: Skein, new_skein: Skein):
	# New skein is in skeins -> select new skein, delete old one
	# New skein is not in skeins -> add the skein
	# Old skein
	
	var old_selected = old_skein == colors[selected_idx]
	var idx = colors.find(new_skein)
	var new_skein_in_colors = idx != -1
	
	if new_skein_in_colors:
		if old_selected:
			selected_idx = idx
	else:
		if old_selected:
			colors.insert(selected_idx, new_skein)
		else:
			colors.append(new_skein)
	colors.erase(old_skein)
	print_debug("Swapped %s with %s" % [old_skein.id, new_skein.id])
	
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)
