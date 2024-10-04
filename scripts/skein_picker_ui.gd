extends Control

@onready var color_rect = $ColorRect
var skein : Skein

func set_values(_skein: Skein):
	self.skein = _skein
	color_rect.self_modulate = _skein.color

func select_color() -> void:
	print_debug("%s (%s) added to palette" % [skein.get_identifying_name(), skein.color_name])
	SignalBus.skein_added_to_palette.emit(skein)
