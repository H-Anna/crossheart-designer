class_name XStitchToolController
extends Node

## Class that interfaces with other classes
## for selecting and using [XStitchTool]s.

## Dictionary of methods and corresponding tools.
@export var tool_dictionary: Dictionary[XStitchTool.Method, XStitchTool]

## Dictionary of methods and corresponding UI elements,
## such as configuration menus.
@export var tool_ui_dictionary: Dictionary[XStitchTool.Method, Control]

## The currently selected tool.
var current_tool: XStitchTool

func _ready() -> void:
	Globals.xstitch_tool_controller = self
	select_tool(XStitchTool.Method.DRAW_ERASE)

#region Getters and Setters

## Returns the current tool.
func get_current_tool() -> XStitchTool:
	return current_tool

## Sets the visibility of tool UI.[br]
## [param method]: the [enum XStitchTool.Method] associated with the tool.[br]
## [param visible]: the visibility to set.
func set_tool_ui_visibility(method: XStitchTool.Method, visible: bool) -> void:
	if method in tool_ui_dictionary:
		tool_ui_dictionary[method].visible = visible

#endregion

#region Tool management

## Selects a tool based on the [param method].
func select_tool(method: XStitchTool.Method) -> void:
	if current_tool:
		set_tool_ui_visibility(current_tool.method, false)
	
	current_tool = tool_dictionary[method]
	
	set_tool_ui_visibility(method, true)
	
	Input.set_custom_mouse_cursor(current_tool.cursor_image, 0, current_tool.cursor_hotspot)
	SignalBus.tool_selected.emit(current_tool)

#endregion
