extends Window

@export var skein_ui : PackedScene

@onready var container := $VBoxContainer/ScrollContainer/SkeinsList
@onready var remove_confirm_dialog := $RemoveConfirmDialog
@onready var swap_confirm_dialog := $SwapConfirmDialog
@onready var swap_skein_window := $"../SwapSkeinWindow" #TODO: race condition
@onready var swap_symbol_window := $"../SwapSymbolWindow" #TODO: race condition

var selected_element: Control

func _ready() -> void:
	SignalBus.palette_ui_changed.connect(_on_palette_changed)
	swap_skein_window.swap_callable = _swap_skein
	swap_symbol_window.swap_callable = _swap_symbol

func _on_palette_changed(palette: Palette):
	_delete_elements()
	_load_colors(palette)

# Deletes all ui elements
func _delete_elements():
	for ui in container.get_children():
		ui.queue_free()

func _load_colors(palette: Palette) -> void:
	## TODO: refactor
	# Loads ui elements
	var selected = false
	var selected_skein = palette.get_selected_skein()
	for skein in palette.colors:
		var symbol = palette.colors_to_symbols_dict.get(skein)
		var ui = skein_ui.instantiate()
		container.add_child(ui)
		ui.set_values(skein, symbol)
		ui.swap_button.pressed.connect(swap_skein_window.set_values.bind(ui.skein))
		ui.swap_button.pressed.connect(swap_skein_window.show)
		
		ui.symbol_button.pressed.connect(swap_symbol_window.set_values.bind(ui.skein, ui.symbol))
		ui.symbol_button.pressed.connect(swap_symbol_window.show)
		
		ui.x_button.pressed.connect(_remove_skein.bind(ui.skein))
		ui.ui_skein_selected.connect(_ui_skein_selected)
		
		if !selected:
			if selected_skein == null:
				ui.select(false)
				selected = true
			elif skein == selected_skein:
				ui.select()
				selected = true
		
		## Select first color in list
		### TODO: reroute color selection to palette object
		#if !selected:
			#ui.select(false)
			#selected = true
	
	# If there's nothing in the palette just send a null.
	if !selected:
		SignalBus.skein_selected.emit(null)

func _ui_skein_selected(control: Control):
	if selected_element == null:
		for child in container.get_children():
			if child != control:
				child.deselect()
			else:
				selected_element = child
	elif control != selected_element:
		selected_element.deselect()
		selected_element = control

func _remove_skein(skein: Skein):
	var confirm_sig = remove_confirm_dialog.confirmed
	var cancel_sig = remove_confirm_dialog.canceled
	var emit_callable = SignalBus.skein_removed_from_palette.emit
	
	remove_confirm_dialog.show()
	Extensions.disconnect_callable(confirm_sig, emit_callable)
	Extensions.disconnect_callable(cancel_sig, Extensions.disconnect_callable)
	
	confirm_sig.connect(emit_callable.bind(skein))
	cancel_sig.connect(Extensions.disconnect_callable.bind(confirm_sig, emit_callable))

func _swap_skein(old_skein: Skein, new_skein: Skein):
	var confirm_sig = swap_confirm_dialog.confirmed
	var cancel_sig = swap_confirm_dialog.canceled
	var emit_callable = SignalBus.skein_swapped.emit
	
	swap_confirm_dialog.show()
	Extensions.disconnect_callable(confirm_sig, emit_callable)
	Extensions.disconnect_callable(cancel_sig, Extensions.disconnect_callable)
	
	confirm_sig.connect(emit_callable.bind(old_skein, new_skein))
	cancel_sig.connect(Extensions.disconnect_callable.bind(confirm_sig, emit_callable))

func _swap_symbol(skein: Skein, old_symbol: Symbol, new_symbol: Symbol):
	SignalBus.symbol_swapped.emit(skein, old_symbol, new_symbol)
