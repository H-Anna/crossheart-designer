class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.

@export var line_scene: PackedScene

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary

## Returns the current mouse position.
func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

## Draws a stitch with the given [param thread] color.
func draw_stitch(thread: XStitchThread, points: Array[Vector2]) -> Line2D:
	var line = line_scene.instantiate() as Line2D
	line.default_color = thread.color
	line.points = points
	add_child(line)
	return line
