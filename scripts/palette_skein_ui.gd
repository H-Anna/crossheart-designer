extends Control

@onready var color_rect = $HBoxContainer/ColorRect
@onready var symbol_rect = $HBoxContainer/ColorRect/SymbolRect
@onready var label = $HBoxContainer/Label
@onready var swap_button = $HBoxContainer/SwapButton
@onready var symbol_button = $HBoxContainer/SymbolButton
@onready var x_button = $HBoxContainer/XButton

@export var selected_color : Color
@export var default_color : Color

var skein : Skein
var symbol : Symbol
var selected: bool = false

signal ui_skein_selected(control: Control)

func set_values(_skein: Skein, _symbol: Symbol):
	self.skein = _skein
	self.symbol = _symbol
	name = _skein.id
	label.text = _skein.color_name
	color_rect.self_modulate = _skein.color
	
	symbol_rect.texture = _symbol.data
	var luminance = _skein.color.get_luminance()
	if luminance > 0.5:
		symbol_rect.self_modulate = Color.BLACK
	else:
		symbol_rect.self_modulate = Color.WHITE

func select(emit_signal: bool = true):
	selected = true
	_update_active_color()
	if emit_signal:
		SignalBus.skein_selected.emit(skein)
	ui_skein_selected.emit(self)

func deselect():
	selected = false
	_update_active_color()

func _update_active_color():
	if selected:
		self.color = selected_color
	else:
		self.color = default_color
