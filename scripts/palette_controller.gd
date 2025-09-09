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
			select_thread(get_thread_index(thread))
		ui_add_thread_container:
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


func add_thread(thread: XStitchThread, index: int = -1) -> int:
	if index >= 0:
		palette.colors.insert(index, thread)
	else:
		palette.colors.append(thread)
		index = palette.colors.size() - 1
	
	palette.colors_to_symbols_dict.get_or_add(thread, SymbolsAtlas.get_random_symbol())
	ui_palette_container.add_thread(thread)
	return index


func select_thread(index: int = -1):
	palette.selected = index
	var thread = get_selected_thread()
	ui_palette_container.select_thread(thread)
	
	if index == -1:
		print_debug("No thread selected.")
	else:
		print_debug("Thread selected: %s" % thread.get_identifying_name())


func remove_thread(thread: XStitchThread):
	if palette.colors.find(thread) == palette.selected:
		select_thread()
	
	palette.colors.erase(thread)
	palette.colors_to_symbols_dict.erase(thread)
	ui_palette_container.remove_thread(thread)


func swap_thread(old_thread: XStitchThread, new_thread: XStitchThread):
	var index: int
	if !palette.colors.has(new_thread):
		var insert_at = palette.colors.find(old_thread)
		add_thread(new_thread, insert_at)
		index = insert_at
	else:
		index = palette.colors.find(new_thread)
	
	if palette.colors.find(old_thread) == palette.selected:
		select_thread(index)
	
	remove_thread(old_thread)
	print_debug("Swapped %s with %s" % [old_thread.id, new_thread.id])


func swap_symbol(thread: XStitchThread, old_symbol: Symbol, new_symbol: Symbol):
	palette.colors_to_symbols_dict[thread] = new_symbol


func get_used_symbols():
	return palette.colors_to_symbols_dict.values()

func get_selected_thread() -> XStitchThread:
	if palette.colors.is_empty() || palette.selected < 0:
		return null
	return palette.colors[palette.selected]

func get_thread_index(thread: XStitchThread) -> int:
	return palette.colors.find(thread)
