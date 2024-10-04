extends Window

@export var skein_ui : PackedScene

@onready var skeins_list := $VBoxContainer/ScrollContainer/SkeinsList
@onready var confirm_window := $ConfirmationDialog

var _skein_to_remove : Skein

func _ready() -> void:
	SignalBus.palette_ui_changed.connect(_on_palette_changed)
	pass

func _on_palette_changed(palette: Palette):
	_load_colors(palette)

func _load_colors(palette: Palette) -> void:
	# Delete all ui elements
	for ui in skeins_list.get_children():
		#ui.x_button.pressed.disconnect(_remove_skein.bind(ui.skein))
		ui.queue_free()
	
	## TODO: refactor
	# Load them again
	var selected = false
	for skein in palette.colors:
		var ui = skein_ui.instantiate()
		skeins_list.add_child(ui)
		ui.set_values(skein)
		ui.x_button.pressed.connect(_remove_skein.bind(ui.skein))
		# Select first color in list
		## TODO: reroute color selection to palette object
		if !selected:
			ui.select_color()
			selected = true

func _remove_skein(skein: Skein):
	confirm_window.show()
	var emit = SignalBus.skein_removed_from_palette.emit
	if confirm_window.confirmed.is_connected(emit):
		confirm_window.confirmed.disconnect(emit)
	confirm_window.confirmed.connect(emit.bind(skein))
