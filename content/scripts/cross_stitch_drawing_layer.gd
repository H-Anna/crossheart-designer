class_name XStitchDrawingLayer
extends TileMapLayer

const CURSOR_TILE := Vector2i(0,0)

var _modulated_tile_cache: Dictionary
var is_dirty := false

func draw_stitch(thread: Skein, cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var offsets = tile_set.get_pattern(size - 1).get_used_cells().map(func(x): return x - Globals.BRUSH_CENTER_POINT[size])
	for coord in offsets:
		if bounding_rect.has_point(cell + coord):
			_set_cell_modulated(cell + coord, thread)
			is_dirty = true


func erase_stitch(cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var offsets = tile_set.get_pattern(size - 1).get_used_cells().map(func(x): return x - Globals.BRUSH_CENTER_POINT[size])
	for coord in offsets:
		if bounding_rect.has_point(cell + coord):
			erase_cell(cell + coord)
			is_dirty = true

func erase_all():
	for cell in get_used_cells():
		erase_cell(cell)

func _set_cell_modulated(cell: Vector2i, thread: Skein) -> void:
	if thread == null:
		set_cell(cell, 0, CURSOR_TILE)
		return
	
	if thread in _modulated_tile_cache:
		set_cell(cell, 0, CURSOR_TILE, _modulated_tile_cache[thread])
		return
	
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var alt_tile_id := source.create_alternative_tile(CURSOR_TILE)
	var tile_data := source.get_tile_data(CURSOR_TILE, alt_tile_id)
	tile_data.modulate = thread.color
	_modulated_tile_cache[thread] = alt_tile_id
	set_cell(cell, 0, CURSOR_TILE, alt_tile_id)

func _erase_cells_with_skein(skein: Skein):
	if _modulated_tile_cache.has(skein):
		var alt_id = _modulated_tile_cache[skein]
		for cell in get_used_cells_by_id(0, CURSOR_TILE, alt_id):
			erase_cell(cell)
			#is_dirty = true
		_modulated_tile_cache.erase(skein)
		#SignalBus.layer_changed.emit(self, false)
