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

## The [Rect2i] boundaries of the canvas.
var tilemap_rect : Rect2i

func _draw() -> void:
	draw_grid(dense_grid_color, dense_steps, dense_line_width)
	draw_grid(sparse_grid_color, sparse_steps, sparse_line_width)

## Returns an array that describes [Vector2] endpoints of a grid.[br]
## [param steps] is the number of tiles to surround.
## The default value is 1, meaning a dense grid is returned.
func get_grid_points(steps: int = 1) -> PackedVector2Array:
	var array: PackedVector2Array
	for y in range(0, tilemap_rect.size.y + 1, steps):
		array.push_back(Vector2(0, y * CELL_SIZE.y))
		array.push_back(Vector2(tilemap_rect.size.x * CELL_SIZE.x, y * CELL_SIZE.y))
	
	for x in range(0, tilemap_rect.size.x + 1, steps):
		array.push_back(Vector2(x * CELL_SIZE.x, 0))
		array.push_back(Vector2(x * CELL_SIZE.x, tilemap_rect.size.y * CELL_SIZE.y))
	
	return array


## Draws a grid with the given [param color], in [param steps] of cells.
func draw_grid(color: Color, steps: int, line_width: float) -> void:
	var grid_points = get_grid_points(steps)
	draw_multiline(grid_points, color, line_width)
