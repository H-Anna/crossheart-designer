class_name XStitchToolController
extends Node

@export var draw_erase_tool: XStitchTool
@export var color_picker_tool: XStitchTool

var current_tool: XStitchTool

func get_current_tool() -> XStitchTool:
	return current_tool

func select_draw_erase_tool():
	current_tool = draw_erase_tool

func select_color_picker_tool():
	current_tool = color_picker_tool
