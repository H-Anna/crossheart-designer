extends Node2D

## Draws static UI elements on and near the canvas, such as guides.

## The size of a single cell on the tilemap.
const CELL_SIZE := Vector2i(16, 16)

## Line width for dense grid.
@export var dense_line_width := -1.0

## Line width for sparse grid.
@export var sparse_line_width := 1.0

## Steps for dense grid.
@export var dense_steps := 1

## Steps for sparse grid.
@export var sparse_steps := 10

## Color used to draw the dense grid (every tile).
@export var dense_grid_color := Color(0.0, 1.0, 0.0)

## Color used to draw the sparse grid (every 10 tiles).
@export var sparse_grid_color := Color(0.0, 1.0, 0.0)

## Color used for centerpoint/halfway point markers.
@export var center_marker_color := Color(0.0, 1.0, 0.0)

## Marker nodes and their positions.
@export var markers : Dictionary[Marker2D, PackedVector2Array]

## The color for line numbers.
@export var line_number_color := Color(0.0, 1.0, 0.0)

## The [Rect2i] boundaries of the canvas.
var tilemap_rect : Rect2i

## Draws static lines and polygons.
func _draw() -> void:
	draw_grid(dense_grid_color, dense_steps, dense_line_width)
	draw_grid(sparse_grid_color, sparse_steps, sparse_line_width)
	
	set_marker_positions()
	draw_markers()
	draw_line_numbers()

## Returns the true canvas size in [Vector2]: the result of the [member tilemap_rect] and the [constant CELL_SIZE].
func get_canvas_size() -> Vector2:
	return Vector2(tilemap_rect.size.x * CELL_SIZE.x, tilemap_rect.size.y * CELL_SIZE.y)

## Returns an array that describes [Vector2] endpoints of a grid.[br]
## [param steps] is the number of tiles to surround.
## The default value is 1, meaning a dense grid is returned.
func get_grid_points(steps: int = dense_steps) -> PackedVector2Array:
	var array: PackedVector2Array
	var canvas_size = get_canvas_size()
	for y in range(0, tilemap_rect.size.y + 1, steps):
		array.push_back(Vector2(0, y * CELL_SIZE.y))
		array.push_back(Vector2(canvas_size.x, y * CELL_SIZE.y))
	
	for x in range(0, tilemap_rect.size.x + 1, steps):
		array.push_back(Vector2(x * CELL_SIZE.x, 0))
		array.push_back(Vector2(x * CELL_SIZE.x, canvas_size.y))
	
	return array

## Repositions each marker child so that they sit at the halfway points
## of the canvas.
func set_marker_positions() -> void:
	var canvas_size = get_canvas_size()
	$North.position = Vector2(canvas_size.x / 2, 0)
	$South.position = Vector2(canvas_size.x / 2, canvas_size.y)
	$West.position = Vector2(0, canvas_size.y / 2)
	$East.position = Vector2(canvas_size.x, canvas_size.y / 2)

## Draws a grid with the given [param color], in [param steps] of cells.
func draw_grid(color: Color, steps: int, line_width: float) -> void:
	var grid_points = get_grid_points(steps)
	draw_multiline(grid_points, color, line_width)

## Draws triangle markers at points specified in [member markers].
func draw_markers() -> void:
	for key in markers:
		var marker_points = markers[key] as Array[Vector2]
		marker_points = marker_points.map(func(x): return x + key.position)
		draw_colored_polygon(marker_points, center_marker_color)

## Draws line numbers at [param steps] along the horizontal and
## vertical edges of the canvas.
func draw_line_numbers(steps: int = sparse_steps) -> void:
	var font: Font = ThemeDB.fallback_font
	var alignment: HorizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
	var width: int = -1
	var font_size: int = 16
	
	var line_numbers = get_line_numbers_dictionary(steps)
	for point in line_numbers:
		draw_string(font, point, line_numbers[point], alignment, width, font_size, line_number_color)

## Returns a dictionary that contains which line numbers to draw at what coordinates.
func get_line_numbers_dictionary(steps: int, char_size: int = 10, margin_absolute: int = 5) -> Dictionary[Vector2, StringName]:
	var result: Dictionary[Vector2, StringName]
	var canvas_size = get_canvas_size()
	
	for y in range(steps, tilemap_rect.size.y, steps):
		var numstr = str(y)
		var margin = numstr.length() * char_size
		var point1 = Vector2(-margin - margin_absolute, y * CELL_SIZE.y + char_size / 2)
		var point2 = Vector2(canvas_size.x + margin_absolute, y * CELL_SIZE.y + char_size / 2)
		result[point1] = numstr
		result[point2] = numstr
	
	for x in range(steps, tilemap_rect.size.x, steps):
		var numstr = str(x)
		var margin = numstr.length() * char_size / 2
		var point1 = Vector2(Vector2(x * CELL_SIZE.x - margin, -margin_absolute))
		var point2 = Vector2(Vector2(x * CELL_SIZE.x - margin, canvas_size.y + char_size + margin_absolute))
		result[point1] = numstr
		result[point2] = numstr
	
	return result
