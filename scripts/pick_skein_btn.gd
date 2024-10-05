extends Button

@onready var color_rect = $ColorRect
var skein : Skein

signal skein_selected(skein: Skein)

func _ready() -> void:
	pressed.connect(select_color)

func set_values(_skein: Skein):
	skein = _skein
	color_rect.self_modulate = _skein.color

func select_color() -> void:
	print_debug("%s (%s) selected (UI)" % [skein.get_identifying_name(), skein.color_name])
	skein_selected.emit(skein)
