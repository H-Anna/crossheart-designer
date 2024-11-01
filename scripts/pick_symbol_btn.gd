extends Button

@onready var color_rect = $ColorRect
@onready var symbol_rect = $ColorRect/SymbolRect
var symbol : Symbol

signal symbol_selected(symbol: Symbol)

func _ready() -> void:
	pressed.connect(select_symbol)

func set_values(_symbol: Symbol, skein_color: Color):
	symbol = _symbol
	color_rect.self_modulate = skein_color
	
	symbol_rect.texture = _symbol.data
	var luminance = skein_color.get_luminance()
	if luminance > 0.5:
		symbol_rect.self_modulate = Color.BLACK
	else:
		symbol_rect.self_modulate = Color.WHITE

func select_symbol() -> void:
	print_debug("%s (%s) selected (UI)" % [symbol.get_identifying_name(), symbol.symbol_name])
	symbol_selected.emit(symbol)
