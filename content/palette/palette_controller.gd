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
	cmd.symbol = SymbolsAtlas.assign_symbol()
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
	palette.threads.clear()
	palette.select_thread(null)


func add_thread(thread: XStitchThread, index: int = -1) -> int:
	if index >= 0:
		palette.threads.insert(index, thread)
	else:
		palette.threads.append(thread)
		index = palette.threads.size() - 1
	
	ui_palette_container.add_thread(thread)
	return index

func pick_thread(thread: XStitchThread):
	select_thread(get_thread_index(thread))

func select_thread(index: int = -1):
	palette.selected = index
	var thread = get_selected_thread()
	ui_palette_container.select_thread(thread)
	
	if index == -1:
		print_debug("No thread selected.")
	else:
		print_debug("Thread selected: %s" % thread.get_identifying_name())


func remove_thread(thread: XStitchThread):
	select_thread()
	palette.threads.erase(thread)
	ui_palette_container.remove_thread(thread)


func swap_thread(old_thread: XStitchThread, new_thread: XStitchThread):
	var index: int
	if !palette.threads.has(new_thread):
		var insert_at = palette.threads.find(old_thread)
		add_thread(new_thread, insert_at)
		index = insert_at
	else:
		index = palette.threads.find(new_thread)
	
	if palette.threads.find(old_thread) == palette.selected:
		select_thread(index)
	
	remove_thread(old_thread)
	print_debug("Swapped %s with %s" % [old_thread.id, new_thread.id])

func get_selected_thread() -> XStitchThread:
	if palette.threads.is_empty() || palette.selected < 0:
		return null
	return palette.threads[palette.selected]

func get_thread_index(thread: XStitchThread) -> int:
	return palette.threads.find(thread)
