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
	if current_tool:
		set_tool_ui_visibility(current_tool.method, false)
	
	current_tool = tool_dictionary[method]
	
	set_tool_ui_visibility(method, true)
	
	Input.set_custom_mouse_cursor(current_tool.cursor_image, 0, current_tool.cursor_hotspot)
	tool_selected.emit(current_tool)

func set_tool_ui_visibility(idx: int, visible: bool):
	if idx < tool_ui_dictionary.size():
		tool_ui_dictionary[idx].visible = visible
