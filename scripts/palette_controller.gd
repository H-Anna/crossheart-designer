class_name PaletteController
extends Node

@export var ui_palette_container: ThreadButtonContainer
@export var ui_add_thread_container: ThreadButtonContainer
@export var ui_swap_thread_container: ThreadButtonContainer

var palette : PaletteModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.palette_controller = self
	palette = PaletteModel.new()
	SignalBus.thread_button_clicked.connect(on_thread_button_pressed)


func on_thread_button_pressed(thread: XStitchThread, button: ThreadButton, container: ThreadButtonContainer):
	match container:
		ui_palette_container:
			select_thread(thread)
		ui_add_thread_container:
			#add_thread(thread)
			add_thread_command(thread)
			%AddThreadMenu.hide()
			%PaletteMenu.show()
		ui_swap_thread_container:
			SignalBus.thread_swap_requested.emit(thread)
			pass
		_: # Anything else
			pass


func add_thread_command(thread: XStitchThread):
	var cmd = AddThreadCommand.new()
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)


func remove_thread_command(thread: XStitchThread):
	var cmd = RemoveThreadCommand.new()
	cmd.palette = palette
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)


func swap_thread_command(old_thread: XStitchThread, new_thread: XStitchThread):
	var cmd = SwapThreadCommand.new()
	cmd.old_thread = old_thread
	cmd.new_thread = new_thread
	SignalBus.command_created.emit(cmd)


func clear_palette():
	palette.colors.clear()
	palette.colors_to_symbols_dict.clear()
	palette.select_thread(null)


func add_thread(thread: XStitchThread):
	palette.colors.append(thread)
	palette.colors_to_symbols_dict.get_or_add(thread, SymbolsAtlas.get_random_symbol())
	ui_palette_container.add_thread(thread)


func select_thread(thread: XStitchThread):
	palette.selected_thread = thread
	ui_palette_container.select_thread(thread)
	%Canvas.thread = thread
	
	if !thread:
		print_debug("No thread selected.")
	else:
		print_debug("Thread selected: %s" % thread.get_identifying_name())

# TODO: selection should be governed by commands instead!
func remove_thread(thread: XStitchThread):
	if thread == palette.selected_thread:
		if palette.colors.size() == 1:
			select_thread(null)
		else:
			var idx = palette.colors.find(thread)
			if idx == 0:
				select_thread(palette.colors[idx + 1])
			else:
				select_thread(palette.colors[idx - 1])
	
	palette.colors.erase(thread)
	palette.colors_to_symbols_dict.erase(thread)
	ui_palette_container.remove_thread(thread)
	SignalBus.thread_removed_from_palette.emit(thread)


func swap_thread(old_thread: XStitchThread, new_thread: XStitchThread):
	if !palette.colors.has(new_thread):
		var idx = palette.colors.find(old_thread)
		palette.colors.insert(idx, new_thread)
		ui_palette_container.add_thread(new_thread)
		
	palette.colors_to_symbols_dict.get_or_add(new_thread, palette.colors_to_symbols_dict.get(old_thread))
	
	if old_thread == palette.selected_thread:
		select_thread(new_thread)
		ui_palette_container.select_thread(new_thread)
	
	palette.colors.erase(old_thread)
	palette.colors_to_symbols_dict.erase(old_thread)
	ui_palette_container.remove_thread(old_thread)
	print_debug("Swapped %s with %s" % [old_thread.id, new_thread.id])


func swap_symbol(thread: XStitchThread, old_symbol: Symbol, new_symbol: Symbol):
	palette.colors_to_symbols_dict[thread] = new_symbol


func get_used_symbols():
	return palette.colors_to_symbols_dict.values()

func get_selected_thread():
	return palette.selected_thread
