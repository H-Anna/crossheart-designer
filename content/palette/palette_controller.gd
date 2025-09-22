class_name PaletteController
extends Node

## A class that controls data and UI operations related to the palette.

## The Palette Container UI element.
@export var ui_palette_container: ThreadButtonContainer

## The Add Thread Container UI element.
@export var ui_add_thread_container: ThreadButtonContainer

## The Swap Thread Container UI element.
@export var ui_swap_thread_container: ThreadButtonContainer

## The palette data.
var palette : PaletteModel

## Binds self to [Globals] for easy access for all classes.
## Initializes the palette.
## Connects self to thread button pressed signal.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.palette_controller = self
	palette = PaletteModel.new()
	SignalBus.thread_button_clicked.connect(on_thread_button_pressed)

## Returns the selected thread.
func get_selected_thread() -> XStitchThread:
	if palette.threads.is_empty() || palette.selected < 0:
		return null
	return palette.threads[palette.selected]

## Returns the array index for a given thread.
func get_thread_index(thread: XStitchThread) -> int:
	return palette.threads.find(thread)

## In response to a thread button press, determines the action to take
## based on the container class.
func on_thread_button_pressed(thread: XStitchThread, button: ThreadButton, container: ThreadButtonContainer) -> void:
	match container:
		ui_palette_container:
			pick_thread(thread)
		ui_add_thread_container:
			add_thread_command(thread)
			%AddThreadMenu.hide()
			%PaletteMenu.show()
		ui_swap_thread_container:
			SignalBus.thread_swap_requested.emit(thread)
			pass
		_: # Anything else
			pass

## Creates an [AddThreadCommand].
func add_thread_command(thread: XStitchThread) -> void:
	var cmd = AddThreadCommand.new()
	cmd.thread = thread
	cmd.symbol = SymbolsAtlas.get_unassigned_symbol()
	SignalBus.command_created.emit(cmd)

## Creates a [RemoveThreadCommand].
func remove_thread_command(thread: XStitchThread) -> void:
	var cmd = RemoveThreadCommand.new()
	cmd.thread = thread
	SignalBus.command_created.emit(cmd)

## Creates a [SwapThreadCommand].
func swap_thread_command(old_thread: XStitchThread, new_thread: XStitchThread) -> void:
	var cmd = SwapThreadCommand.new()
	cmd.old_thread = old_thread
	cmd.new_thread = new_thread
	SignalBus.command_created.emit(cmd)

## @experimental: Unused.
## Deletes all threads from the palette.
func clear_palette() -> void:
	palette.threads.clear()
	palette.select_thread(null)

## Adds a thread to the palette.
## Prompts [member ui_palette_container] to add it as a button to itself.
func add_thread(thread: XStitchThread, index: int = -1) -> int:
	if index >= 0:
		palette.threads.insert(index, thread)
	else:
		palette.threads.append(thread)
		index = palette.threads.size() - 1
	
	ui_palette_container.add_thread(thread)
	return index

## Selects a thread by value instead of by index.
func pick_thread(thread: XStitchThread) -> void:
	select_thread(get_thread_index(thread))

## Selects a thread by index.
func select_thread(index: int = -1) -> void:
	palette.selected = index
	var thread = get_selected_thread()
	ui_palette_container.select_thread(thread)
	
	if index == -1:
		print_debug("No thread selected.")
	else:
		print_debug("Thread selected: %s" % thread.get_identifying_name())

## Removes a thread from the palette.
## Prompts [member ui_palette_container] to remove its button.
func remove_thread(thread: XStitchThread) -> void:
	#select_thread()
	palette.threads.erase(thread)
	ui_palette_container.remove_thread(thread)

## Swaps a thread for a new one in the palette.
func swap_thread(old_thread: XStitchThread, new_thread: XStitchThread) -> void:
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
