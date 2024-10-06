extends Control

@onready var color_rect = $HBoxContainer/ColorRect
@onready var label = $HBoxContainer/Label
@onready var swap_button = $HBoxContainer/SwapButton
@onready var x_button = $HBoxContainer/XButton
var skein : Skein

func set_values(_skein: Skein):
	self.skein = _skein
	name = _skein.id
	label.text = _skein.color_name
	color_rect.self_modulate = _skein.color

func select_color():
	print_debug("Now painting with: %s (%s)" % [skein.get_identifying_name(), skein.color_name])
	SignalBus.skein_selected.emit(skein)
