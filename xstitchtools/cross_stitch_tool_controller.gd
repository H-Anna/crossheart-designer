class_name XStitchToolController
extends Node

signal tool_selected(tool: XStitchTool)

@export var tool_dictionary: Dictionary[XStitchTool.Method, XStitchTool]
@export var tool_ui_dictionary: Dictionary[XStitchTool.Method, Control]

var current_tool: XStitchTool

func _ready() -> void:
	select_tool(XStitchTool.Method.DRAW_ERASE)

func get_current_tool() -> XStitchTool:
	return current_tool

func select_tool(method: XStitchTool.Method):
	if current_tool && tool_ui_dictionary[current_tool.method]:
		tool_ui_dictionary[current_tool.method].hide()
	
	current_tool = tool_dictionary[method]
	
	if tool_ui_dictionary[current_tool.method]:
		tool_ui_dictionary[current_tool.method].show()
	
	Input.set_custom_mouse_cursor(current_tool.cursor_image, 0, current_tool.cursor_hotspot)
	tool_selected.emit(current_tool)
