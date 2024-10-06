extends Control

@onready var name_edit = $HBoxContainer/NameEdit
@onready var show_hide_button = $HBoxContainer/ShowHideButton
@onready var x_button = $HBoxContainer/XButton

@export var selected_color : Color
@export var default_color : Color
@export var default_name := "New layer"

var layer: TileMapLayer
var order: int
var layer_visible: bool = true
var selected: bool = false

signal layer_selected(layer: TileMapLayer)
signal ui_layer_selected(control: Control)
signal layer_renamed(layer: TileMapLayer, new_name: String)
#signal layer_reordered(layer: TileMapLayer, order: int)
signal layer_deleted(layer: TileMapLayer)
signal layer_visibility_toggled(layer: TileMapLayer, is_visible: bool)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.double_click:
		name_edit.editable = true
		name_edit.grab_focus()
		accept_event()

func set_values(_layer: TileMapLayer):
	layer = _layer
	var display_name = layer.get_display_name()
	_update_name_edit_text(display_name)
	
	selected = layer.active
	_update_active_color()
	
	layer_visible = layer.visible
	_update_show_hide_button()

func select(emit_signal: bool = true):
	selected = true
	_update_active_color()
	if emit_signal:
		layer_selected.emit(layer)
	ui_layer_selected.emit(self)

func deselect():
	selected = false
	_update_active_color()

func _on_name_edit_text_submitted(_new_text: String) -> void:
	if _new_text.is_empty():
		_new_text = default_name
	
	name_edit.editable = false
	name_edit.release_focus()
	layer_renamed.emit(layer, _new_text)
	_update_name_edit_text(_new_text)

func _on_delete_layer():
	layer_deleted.emit(layer)

func _on_layer_toggle_visibility():
	layer_visible = !layer_visible
	_update_show_hide_button()
	layer_visibility_toggled.emit(layer, layer_visible)

func _update_show_hide_button():
	if layer_visible:
		show_hide_button.text = "Hide"
	else:
		show_hide_button.text = "Show"

func _update_active_color():
	if selected:
		self.color = selected_color
	else:
		self.color = default_color

func _update_name_edit_text(text: String):
	if text.is_empty():
		name_edit.text = default_name
	else:
		name_edit.text = text
