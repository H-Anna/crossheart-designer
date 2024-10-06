extends Window

@export var skein_ui : PackedScene

@onready var skeins_list := $VBoxContainer/ScrollContainer/SkeinsList
@onready var remove_confirm_dialog := $RemoveConfirmDialog
@onready var swap_confirm_dialog := $SwapConfirmDialog
@onready var swap_skein_window := $"../SwapSkeinWindow" #TODO: race condition

func _ready() -> void:
	SignalBus.palette_ui_changed.connect(_on_palette_changed)
	swap_skein_window.swap_callable = _swap_skein

func _on_palette_changed(palette: Palette):
	_delete_elements()
	_load_colors(palette)

# Deletes all ui elements
func _delete_elements():
	for ui in skeins_list.get_children():
		ui.queue_free()

func _load_colors(palette: Palette) -> void:
	## TODO: refactor
	# Loads ui elements
	var selected = false
	for skein in palette.colors:
		var ui = skein_ui.instantiate()
		skeins_list.add_child(ui)
		ui.set_values(skein)
		ui.swap_button.pressed.connect(swap_skein_window.set_skein_to_swap.bind(ui.skein))
		ui.swap_button.pressed.connect(swap_skein_window.show)
		ui.x_button.pressed.connect(_remove_skein.bind(ui.skein))
		
		# Select first color in list
		## TODO: reroute color selection to palette object
		if !selected:
			ui.select_color()
			selected = true
	
	if !selected:
		SignalBus.skein_selected.emit(null)

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
