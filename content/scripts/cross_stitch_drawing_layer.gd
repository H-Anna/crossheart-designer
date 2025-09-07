class_name XStitchDrawingLayer
extends TileMapLayer

var CURSOR_TILE := Vector2i(0,0)

var _modulated_tile_cache: Dictionary

func _ready() -> void:
	SignalBus.thread_swapped.connect(_swap_cells_with_thread)
	SignalBus.thread_removed_from_palette.connect(_erase_cells_with_thread)

func get_mouse_position():
	return local_to_map(get_global_mouse_position())

func draw_pixel(thread: XStitchThread, cell: Vector2i):
	_set_cell_modulated(cell, thread)

func erase_pixel(cell: Vector2i):
	erase_cell(cell)

func get_stitch_at(cell: Vector2i):
	return _modulated_tile_cache.find_key(get_cell_alternative_tile(cell))

func get_brush_area(center: Vector2i, size: int):
	# Get the used cells of a given brush size
	var brush_cells = tile_set.get_pattern(size - 1).get_used_cells()
	# Offset the cells so that they are in the context of the layer
	var layer_cells = brush_cells.map(func(x): return x - Globals.BRUSH_CENTER_POINT[size] + center)
	return layer_cells

func draw_stitch(thread: XStitchThread, cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var pixels = get_brush_area(cell, size)
	for pixel in pixels:
		if bounding_rect.has_point(pixel):
			_set_cell_modulated(pixel, thread)

func erase_stitch(cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var pixels = get_brush_area(cell, size)
	for pixel in pixels:
		if bounding_rect.has_point(pixel):
			erase_cell(pixel)

func erase_all():
	for cell in get_used_cells():
		erase_cell(cell)

func _set_cell_modulated(cell: Vector2i, thread: XStitchThread, tile: Vector2i = CURSOR_TILE) -> void:
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

func _erase_cells_with_thread(thread: XStitchThread):
	if _modulated_tile_cache.has(thread):
		var alt_id = _modulated_tile_cache[thread]
		for cell in get_used_cells_by_id(0, CURSOR_TILE, alt_id):
			erase_cell(cell)
		_modulated_tile_cache.erase(thread)

func _swap_cells_with_thread(old_thread: XStitchThread, new_thread: XStitchThread):
	if !_modulated_tile_cache.has(old_thread):
		return
	
	var old_alt_id = _modulated_tile_cache[old_thread]
	for cell in get_used_cells_by_id(0, CURSOR_TILE, old_alt_id):
		_set_cell_modulated(cell, new_thread)

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
			_set_cell_modulated(cell, thread, tile)
