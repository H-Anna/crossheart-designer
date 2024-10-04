extends Control

@onready var color_rect = $MarginContainer/HBoxContainer/ColorRect
@onready var label = $MarginContainer/HBoxContainer/Label
@onready var x_button = $MarginContainer/HBoxContainer/XButton
var skein : Skein

func set_values(_skein: Skein):
	self.skein = _skein
	name = _skein.id
	label.text = _skein.color_name
	color_rect.self_modulate = _skein.color

func select_color():
	print_debug("%s (%s) selected" % [skein.get_identifying_name(), skein.color_name])
	SignalBus.skein_selected.emit(skein)
