class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.
## Maintains a 'preview line' for user feedback.
## @experimental: This class needs refactoring in the method names.

enum CursorSnap { GRID = 0, DENSE = 1, FREEFORM = 2}

## The [Line2D] scene used to create backstitches.
@export var line_scene: PackedScene

## The color of this layer when the backstitch tool is not in use.
@export var unfocused_modulate: Color

## The maximum distance the cursor can be from a stitch,
## while erasing backstitches.
@export var maximum_erase_distance: float = 2.0

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary[XStitchThread, Array] = {}

## Array of backstitch [Line2D]s the layer keeps track of.
var tracked_lines: Array[Line2D]

## Returns the current mouse position.
func get_mouse_position() -> Vector2:
	var snap = Globals.xstitch_tool_controller.get_current_tool().get_meta("snap")
	match snap:
		CursorSnap.GRID:
			return get_global_mouse_position().snapped(Globals.CELL_SIZE)
		CursorSnap.DENSE:
			return get_global_mouse_position().snapped(Globals.CELL_SIZE / 2)
		CursorSnap.FREEFORM:
			return get_global_mouse_position()
		_:
			print_debug("ERROR: Value ", snap, " does not exist in enum CursorSnap")
			return get_global_mouse_position()

## Returns an array of [Line2D] near a specific point.
func get_line2ds_near_point(point: Vector2) -> Array[Line2D]:
	var result : Array[Line2D] = []
	
	for line in tracked_lines:
		# Take the closest point to the cursor position along the Line2D.
		var closest_point = Geometry2D.get_closest_point_to_segment(point, line.points[0], line.points[-1])
		
		# If the distance between two points is closer than some arbitrary number,
		# it is "close enough".
		var distance = point.distance_to(closest_point)
		if distance <= maximum_erase_distance:
			result.push_back(line)
	
	return result

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
		tracked_lines.push_back(line)

### Erases backstitches made with the given [param thread].
func erase_with_thread(thread: XStitchThread) -> Array:
	var used_lines : Array
	
	# If the cache contains this thread, get all lines that use it,
	# and erase them. Then remove the line children.
	if _modulated_stitches_cache.has(thread):
		used_lines = _modulated_stitches_cache[thread]
		
		for line in used_lines:
			remove_child(line)
			tracked_lines.erase(line)
			
		_modulated_stitches_cache.erase(thread)
	
	return used_lines
