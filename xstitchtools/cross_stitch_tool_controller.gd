class_name XStitchToolController
extends Node

signal tool_selected(tool: XStitchTool)

@export var draw_erase_tool: XStitchTool
@export var color_picker_tool: XStitchTool

@export var ui_draw_erase_tool_button: Button
@export var ui_draw_erase_tool_settings: Control
@export var ui_color_picker_tool_button: Button

@onready var ui_settings : Array[Control] = [ui_draw_erase_tool_settings]

var current_tool: XStitchTool

func _ready() -> void:
	select_draw_erase_tool()

func get_current_tool() -> XStitchTool:
	return current_tool

func select_draw_erase_tool():
	current_tool = draw_erase_tool
	Input.set_custom_mouse_cursor(current_tool.cursor_image, 0, current_tool.cursor_hotspot)
	for elem in ui_settings:
		elem.hide()
	ui_draw_erase_tool_settings.show()
	tool_selected.emit(current_tool)

func select_color_picker_tool():
	current_tool = color_picker_tool
	Input.set_custom_mouse_cursor(current_tool.cursor_image, 0, current_tool.cursor_hotspot)
	for elem in ui_settings:
		elem.hide()
	tool_selected.emit(current_tool)
