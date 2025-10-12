class_name BackStitchDrawingLayer
extends Node2D

## A drawing layer meant to hold [Line2D] data, to replicate a backstitch layer.
## Maintains a 'preview line' for user feedback.

enum CursorSnap { GRID = 0, DENSE = 1, FREEFORM = 2}

## The [Line2D] scene used to create backstitches.
@export var line_scene: PackedScene

## The color of this layer when the backstitch tool is not in use.
@export var unfocused_modulate: Color

@export var maximum_erase_distance: float = 2.0

## Dictionary with [XStitchThread] keys and arrays of [Line2D] for values.
var _modulated_stitches_cache: Dictionary[XStitchThread, Array] = {}

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

func get_line2ds_near_point(point: Vector2) -> Array[Line2D]:
	var result : Array[Line2D] = []
	
	var lines = get_children()
	lines.erase($PreviewBackstitch)
	for line in lines:
		# Heuristics: a point MAY be close enough to a line if it is within an enclosing rectangle.
		# TODO: create script for line and move it there
		var enclosure = get_enclosure(line)
		if !enclosure.has_point(point):
			continue
		
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

## Returns an enclosing rectangle for a [param line].
func get_enclosure(line: Line2D) -> Rect2:
	var min_x = minf(line.points[0].x, line.points[-1].x)
	var min_y = minf(line.points[0].y, line.points[-1].y)
	var max_x = maxf(line.points[0].x, line.points[-1].x)
	var max_y = maxf(line.points[0].y, line.points[-1].y)
	var width = max_x - min_x
	var height = max_y - min_y
	return Rect2(min_x, min_y, width, height).grow(maximum_erase_distance)
