class_name XStitchDrawingLayer
extends TileMapLayer

var CURSOR_TILE := Vector2i(0,0)

var _modulated_tile_cache: Dictionary

func _ready() -> void:
	pass

func get_mouse_position():
	return local_to_map(get_global_mouse_position())

func get_stitch_at(cell: Vector2i):
	return _modulated_tile_cache.find_key(get_cell_alternative_tile(cell))

func get_brush_area(center: Vector2i, size: int):
	# Get the used cells of a given brush size
	var brush_cells = tile_set.get_pattern(size - 1).get_used_cells()
	# Offset the cells to given center point
	var offset = Globals.BRUSH_CENTER_POINT[size] + center
	var cells = brush_cells.map(func(x): return x + offset)
	return cells

func draw_stitch(thread: XStitchThread, center: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var cells = get_brush_area(center, size)
	for cell in cells:
		if bounding_rect.has_point(cell):
			draw_cell(cell, thread)

func erase_stitch(cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var cells = get_brush_area(cell, size)
	for c in cells:
		if bounding_rect.has_point(c):
			erase_cell(c)

func erase_all():
	for cell in get_used_cells():
		erase_cell(cell)


func draw_cell(cell: Vector2i, thread: XStitchThread, tile: Vector2i = CURSOR_TILE) -> void:
	if thread == null:
		set_cell(cell, 0, tile)
		return
	
	if thread in _modulated_tile_cache:
		set_cell(cell, 0, tile, _modulated_tile_cache[thread])
		return
	
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var alt_tile_id := source.create_alternative_tile(tile)
	var tile_data := source.get_tile_data(tile, alt_tile_id)
	tile_data.modulate = thread.color
	_modulated_tile_cache[thread] = alt_tile_id
	set_cell(cell, 0, tile, alt_tile_id)


func _erase_cells_with_thread(thread: XStitchThread) -> Array[Vector2i]:
	var used_cells : Array[Vector2i]
	
	if _modulated_tile_cache.has(thread):
		var alt_id = _modulated_tile_cache[thread]
		used_cells = get_used_cells_by_id(0, CURSOR_TILE, alt_id)
		for cell in used_cells:
			erase_cell(cell)
		_modulated_tile_cache.erase(thread)
	
	return used_cells


func add_stitches(thread: XStitchThread, context: Array[Vector2i]):
	for cell in context:
		draw_cell(cell, thread)


func serialize():
	var data = []
	for thread in _modulated_tile_cache:
		var threads_coords_dict = {}
		var alt_id = _modulated_tile_cache[thread]
		threads_coords_dict.get_or_add("thread_id", thread.get_identifying_name())
		threads_coords_dict.get_or_add("tile", CURSOR_TILE)
		threads_coords_dict.get_or_add("coordinates", get_used_cells_by_id(0, CURSOR_TILE, alt_id))
		data.append(threads_coords_dict)
	return data

func deserialize(data: Array):
	clear()
	_modulated_tile_cache.clear()
	
	for stitches in data:
		var thread_id = stitches.get("thread_id")
		var tile = stitches.get("tile")
		var coordinates = stitches.get("coordinates")
		
		var thread = ThreadsAtlas.get_thread_by_global_id(thread_id)
		for cell in coordinates:
			draw_cell(cell, thread, tile)
