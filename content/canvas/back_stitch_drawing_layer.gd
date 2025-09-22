class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary

## Returns the current mouse position.
func get_mouse_position() -> Vector2:
	return get_global_mouse_position()
