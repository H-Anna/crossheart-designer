class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.
## Maintains a 'preview line' for user feedback.

@export var line_scene: PackedScene

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary[XStitchThread, Array] = {}

## Returns the current mouse position.
func get_mouse_position() -> Vector2:
	return get_global_mouse_position()

## Sets the preview line visibility.
func set_preview_backstitch_visible(show: bool) -> void:
	$PreviewBackstitch.visible = show

## Sets the preview line color.
func set_preview_backstitch_color(color: Color) -> void:
	$PreviewBackstitch.default_color = color

## Sets the preview line points.
func set_preview_backstitch_points(points: Array[Vector2]) -> void:
	$PreviewBackstitch.points = points

## Draws a stitch with the given [param thread] color.
func draw_stitch(thread: XStitchThread, points: Array[Vector2]) -> Line2D:
	var line = line_scene.instantiate() as Line2D
	line.default_color = thread.color
	line.points = points
	
	if !_modulated_stitches_cache.has(thread):
		_modulated_stitches_cache[thread] = []
	_modulated_stitches_cache[thread].push_back(line)
	
	add_child(line)
	return line

## Adds stitches with the given [param thread] color based on the [param context].
func add_stitches(thread: XStitchThread, context: Array):
	if !_modulated_stitches_cache.has(thread):
		_modulated_stitches_cache[thread] = []
	
	for line in context:
		add_child(line)
		_modulated_stitches_cache[thread].push_back(line)

### Erases backstitches made with the given [param thread].
func erase_with_thread(thread: XStitchThread) -> Array:
	var used_lines : Array
	
	# If the cache contains this thread, get all lines that use it,
	# and erase them. Then remove the line children.
	if _modulated_stitches_cache.has(thread):
		used_lines = _modulated_stitches_cache[thread]
		
		for line in used_lines:
			remove_child(line)
			
		_modulated_stitches_cache.erase(thread)
	
	return used_lines
