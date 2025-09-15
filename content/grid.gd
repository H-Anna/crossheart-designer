extends Node2D

@export var tilemap_cell_size := Vector2i(16, 16)
@export var small_grid_color := Color(0.0, 1.0, 0.0)
@export var large_grid_color := Color(0.0, 1.0, 0.0)
@export var triangle_color := Color(1.0, 0.0, 0.0)
@export var triangle_points : Array[Vector2]
@export var large_grid_thickness := 1.5
@export var zoom_tolerance := 1.0
var tilemap_rect : Rect2i
var current_zoom_level : float

func _draw() -> void:
	if current_zoom_level >= zoom_tolerance:
		_draw_grid(small_grid_color)
	var thickness = clampf(large_grid_thickness / current_zoom_level, large_grid_thickness, 5)
	_draw_grid(large_grid_color, 10, thickness)
	_draw_coordinates(10)
	
	for direction in range(0, 4):
		var t = _calculate_triangle(triangle_points, direction)
		var packed = Extensions.to_packedvector2array(t)
		_draw_triangle(packed, triangle_color)

func _on_canvas_size_changed(new_rect: Rect2i) -> void:
	tilemap_rect = new_rect
	queue_redraw()

func _on_zoom_level_changed(value: float) -> void:
	current_zoom_level = value
	queue_redraw()


func _draw_grid(color: Color, steps: int = 1, line_width: float = -1.0):
	for y in range(0, tilemap_rect.size.y + 1, steps):
		draw_line(Vector2(0, y * tilemap_cell_size.y), Vector2(tilemap_rect.size.x * tilemap_cell_size.x, y * tilemap_cell_size.y), color, line_width)
	
	for x in range(0, tilemap_rect.size.x + 1, steps):
		draw_line(Vector2(x * tilemap_cell_size.x, 0), Vector2(x * tilemap_cell_size.x, tilemap_rect.size.y * tilemap_cell_size.y), color, line_width)


func _draw_triangle(points: PackedVector2Array, color: Color):
	draw_polygon(points, [color])

func _draw_coordinates(steps: int):
	for y in range(steps, tilemap_rect.size.y + 1, steps):
		draw_string(ThemeDB.fallback_font, Vector2(- tilemap_cell_size.x * 2, tilemap_cell_size.y * (y + 0.5)), str(y), HORIZONTAL_ALIGNMENT_RIGHT, -1, ThemeDB.fallback_font_size)
	
	for x in range(steps, tilemap_rect.size.x + 1, steps):
		draw_string(ThemeDB.fallback_font, Vector2(tilemap_cell_size.x * (x - 0.5), 0), str(x), HORIZONTAL_ALIGNMENT_RIGHT, -1, ThemeDB.fallback_font_size)

func _calculate_triangle(v: Array[Vector2], direction: int):
	match direction:
		0: return v.map(func(p): return Vector2(p.x + tilemap_cell_size.x * ((tilemap_rect.size.x / 2) - 0.5), p.y))
		1: return v.map(func(p): return Vector2(p.y, -p.x + (tilemap_rect.size.y / 2 + 0.5) * tilemap_cell_size.y))
		2: return v.map(func(p): return Vector2(-p.y + tilemap_rect.size.x * tilemap_cell_size.x, -p.x + (tilemap_rect.size.y / 2 + 0.5) * tilemap_cell_size.y))
		3: return v.map(func(p): return Vector2(-p.x + tilemap_cell_size.x * (tilemap_rect.size.x / 2 + 0.5), -p.y + tilemap_cell_size.y * tilemap_rect.size.y))
		_: return v
