class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.
## Maintains a 'preview line' for user feedback.

## The [Line2D] scene used to create backstitches.
@export var line_scene: PackedScene

## The color of this layer when the backstitch tool is not in use.
@export var unfocused_modulate: Color

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary[XStitchThread, Array] = {}

func _ready() -> void:
	SignalBus.tool_selected.connect(on_tool_selected)

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

## Modulates self and all children when the backstitch tool is not selected.
## Causes backstitches to be slightly transparent.
func on_tool_selected(tool: XStitchTool) -> void:
	if tool.method == XStitchTool.Method.BACKSTITCH:
		modulate = Color.WHITE
	else:
		modulate = unfocused_modulate

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
