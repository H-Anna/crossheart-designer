class_name Palette
extends Node

@export var colors : Array[XStitchThread]
var colors_to_symbols_dict : Dictionary
var selected_thread : XStitchThread

func _ready() -> void:
	Globals.palette = self
	
	SignalBus.thread_added_to_palette.connect(add_thread_command)
	SignalBus.thread_removed_from_palette.connect(remove_thread_command)
	SignalBus.thread_swapped.connect(swap_thread_command)
	SignalBus.symbol_swapped.connect(swap_symbol)
	SignalBus.thread_selected.connect(select_thread)

func clear():
	colors.clear()
	colors_to_symbols_dict.clear()
	SignalBus.palette_ui_changed.emit(self)

func add_thread_command(thread: XStitchThread):
	var cmd = AddThreadCommand.new()
	cmd.palette = self
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)

func remove_thread_command(thread: XStitchThread):
	var cmd = RemoveThreadCommand.new()
	cmd.palette = self
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)

func swap_thread_command(old_thread: XStitchThread, new_thread: XStitchThread):
	var cmd = SwapThreadCommand.new()
	cmd.palette = self
	cmd.old_thread = old_thread
	cmd.new_thread = new_thread
	SignalBus.command_created.emit(cmd)

func serialize():
	var arr = []
	for thread in colors:
		var elem = {}
		elem.get_or_add("brand", thread.brand)
		elem.get_or_add("id", thread.id)
		elem.get_or_add("global_id", thread.get_identifying_name())
		elem.get_or_add("color_name", thread.color_name)
		elem.get_or_add("color_hex", thread.color.to_html(false))
		elem.get_or_add("symbol", colors_to_symbols_dict.get(thread).get_identifying_name())
		arr.append(elem)
	return arr

func deserialize(data: Array):
	colors.clear()
	colors_to_symbols_dict.clear()
	for dict in data:
		var thread = ThreadsAtlas.get_thread_by_global_id(dict["global_id"])
		var symbol = SymbolsAtlas.get_symbol_by_global_id(dict["symbol"])
		colors.append(thread)
		colors_to_symbols_dict.get_or_add(thread, symbol)
	SignalBus.palette_ui_changed.emit(self)

func add_thread(thread: XStitchThread):
	colors.append(thread)
	colors_to_symbols_dict.get_or_add(thread, SymbolsAtlas.get_random_symbol())
	if !selected_thread:
		select_thread(thread)
	SignalBus.palette_ui_changed.emit(self)

func remove_thread(thread: XStitchThread):
	if thread == selected_thread:
		if colors.size() == 1:
			selected_thread = null
		else:
			var idx = colors.find(thread)
			if idx == 0:
				selected_thread = colors[idx + 1]
			else:
				selected_thread = colors[idx - 1]
	
	colors.erase(thread)
	colors_to_symbols_dict.erase(thread)
	SignalBus.palette_ui_changed.emit(self)

func select_thread(thread: XStitchThread):
	selected_thread = thread

func swap_thread(old_thread: XStitchThread, new_thread: XStitchThread):
	# New thread is in threads -> select new thread, delete old one
	# New thread is not in threads -> add the thread
	# Old thread
	if !colors.has(new_thread):
		var idx = colors.find(old_thread)
		colors.insert(idx, new_thread)
		
	colors_to_symbols_dict.get_or_add(new_thread, colors_to_symbols_dict.get(old_thread))
	
	if old_thread == selected_thread:
		selected_thread = new_thread
	
	colors.erase(old_thread)
	colors_to_symbols_dict.erase(old_thread)
	print_debug("Swapped %s with %s" % [old_thread.id, new_thread.id])
	
	SignalBus.palette_ui_changed.emit(self)

func swap_symbol(thread: XStitchThread, old_symbol: Symbol, new_symbol: Symbol):
	colors_to_symbols_dict[thread] = new_symbol
	SignalBus.palette_ui_changed.emit(self)
