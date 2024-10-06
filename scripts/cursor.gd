class_name Cursor
extends Node2D

var cursor_position : Vector2
var cursor_size : int = 1
var active_skein : Skein = null
@export var minimum_cursor_size := 1
@export var maximum_cursor_size := 5
var tool_mode : = Helpers.ToolMode.NONE

signal cursor_size_changed(new_size: int)
signal cursor_color_changed(new_color: Color)

func _ready() -> void:
	SignalBus.skein_selected.connect(update_cursor_color)

func _process(_delta: float) -> void:
	cursor_position = get_global_mouse_position()
	update_tool_mode()
	update_cursor_size()

func update_tool_mode():
	if Input.is_action_pressed("erase"):
		tool_mode = Helpers.ToolMode.ERASE
	elif Input.is_action_pressed("draw"):
		tool_mode = Helpers.ToolMode.DRAW
	else:
		tool_mode = Helpers.ToolMode.NONE

func update_cursor_size():
	if Input.is_action_just_pressed("increase-brush-size"):
		resize_cursor(1)
	if Input.is_action_just_pressed("decrease-brush-size"):
		resize_cursor(-1)

func update_cursor_color(skein: Skein):
	active_skein = skein
	if skein != null:
		cursor_color_changed.emit(skein.color)
	else:
		cursor_color_changed.emit(Color.TRANSPARENT)

func resize_cursor(delta: int):
	var new_size = cursor_size + delta
	cursor_size = clampi(new_size, minimum_cursor_size, maximum_cursor_size)
	cursor_size_changed.emit(cursor_size)
