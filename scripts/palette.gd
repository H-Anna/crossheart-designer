class_name Palette
extends Node

@export var colors : Array[Skein]
var colors_to_symbols_dict : Dictionary
var selected_thread : Skein

func _ready() -> void:
	SignalBus.skein_added_to_palette.connect(add_thread_command)
	#SignalBus.skein_added_to_palette.connect(add_skein)
	SignalBus.skein_removed_from_palette.connect(remove_thread_command)
	#SignalBus.skein_removed_from_palette.connect(remove_skein)
	SignalBus.skein_swapped.connect(swap_thread_command)
	SignalBus.symbol_swapped.connect(swap_symbol)
	
	SignalBus.skein_selected.connect(select_skein)
	#SignalBus.current_snapshot_changed.connect(deserialize)

func clear():
	colors.clear()
	colors_to_symbols_dict.clear()
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func add_thread_command(thread: Skein):
	var cmd = AddThreadCommand.new()
	cmd.palette = self
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)

func remove_thread_command(thread: Skein):
	var cmd = RemoveThreadCommand.new()
	cmd.palette = self
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)

func swap_thread_command(old_thread: Skein, new_thread: Skein):
	var cmd = SwapThreadCommand.new()
	cmd.palette = self
	cmd.old_thread = old_thread
	cmd.new_thread = new_thread
	SignalBus.command_created.emit(cmd)

func serialize() -> Array:
	var arr : Array[Dictionary]
	for skein in colors:
		var elem : Dictionary
		elem.get_or_add("brand", skein.brand)
		elem.get_or_add("id", skein.id)
		elem.get_or_add("global_id", skein.get_identifying_name())
		elem.get_or_add("color_name", skein.color_name)
		elem.get_or_add("color_hex", skein.color.to_html(false))
		elem.get_or_add("symbol", colors_to_symbols_dict.get(skein).get_identifying_name())
		arr.append(elem)
	return arr

func deserialize(snapshot: Snapshot):
	colors.clear()
	colors_to_symbols_dict.clear()
	var data = snapshot.state["palette"] as Array
	for dict in data:
		var skein = SkeinsAtlas.get_skein_by_global_id(dict["global_id"])
		var symbol = SymbolsAtlas.get_symbol_by_global_id(dict["symbol"])
		colors.append(skein)
		colors_to_symbols_dict.get_or_add(skein, symbol)
	SignalBus.palette_ui_changed.emit(self)

func add_skein(skein: Skein):
	colors.append(skein)
	colors_to_symbols_dict.get_or_add(skein, SymbolsAtlas.get_random_symbol())
	if !selected_thread:
		select_skein(skein)
	#SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func remove_skein(skein: Skein):
	if skein == selected_thread:
		if colors.size() == 1:
			selected_thread = null
		else:
			var idx = colors.find(skein)
			if idx == 0:
				selected_thread = colors[idx + 1]
			else:
				selected_thread = colors[idx - 1]
	
	colors.erase(skein)
	colors_to_symbols_dict.erase(skein)
	
	#SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func select_skein(skein: Skein):
	selected_thread = skein

func swap_skein(old_skein: Skein, new_skein: Skein):
	# New skein is in skeins -> select new skein, delete old one
	# New skein is not in skeins -> add the skein
	# Old skein
	if !colors.has(new_skein):
		var idx = colors.find(old_skein)
		colors.insert(idx, new_skein)
		
	colors_to_symbols_dict.get_or_add(new_skein, colors_to_symbols_dict.get(old_skein))
	
	#if old_skein == selected_thread:
		#selected_thread = new_skein
	
	colors.erase(old_skein)
	colors_to_symbols_dict.erase(old_skein)
	print_debug("Swapped %s with %s" % [old_skein.id, new_skein.id])
	
	#SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func swap_symbol(skein: Skein, old_symbol: Symbol, new_symbol: Symbol):
	colors_to_symbols_dict[skein] = new_symbol
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)
