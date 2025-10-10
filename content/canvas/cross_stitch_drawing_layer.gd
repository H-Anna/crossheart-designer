class_name XStitchDrawingLayer
extends TileMapLayer

## A drawing layer that uses [TileMapLayer] API. Draws tiles at
## [Vector2i] positions in response to mouse input.
## @experimental: This class needs refactoring in the method names.
# TODO refactor method names

## The color of this layer when the drawing tool is not in use.
@export var unfocused_modulate: Color

## @experimental: This member is subject to change.
## The coordinates of the tile being used in the tilemap.
const CURSOR_TILE = Vector2i(0,0)

## Dictionary that contains integer keys and [XStitchThread] values.[br]
## As threads are used on a given layer, modulating individual tiles is
## achieved by adding alternative tile IDs. This dictionary stores which
## alternative ID corresponds to which thread.
var _modulated_tile_cache: Dictionary

## Returns the cell under the mouse pointer.
func get_mouse_position() -> Vector2i:
	return local_to_map(get_global_mouse_position())

## Returns the thread used in a cell.
func get_stitch_at(cell: Vector2i) -> XStitchThread:
	return _modulated_tile_cache.find_key(get_cell_alternative_tile(cell))

## Returns array of [Vector2i] cells covered by the given brush area.
func get_brush_area(center: Vector2i, size: int) -> Array:
	# Get the used cells of a given brush size
	var brush_cells = tile_set.get_pattern(size - 1).get_used_cells()
	# Offset the cells to given center point
	var offset = center - Globals.BRUSH_CENTER_POINT[size]
	var cells = brush_cells.map(func(x): return x + offset)
	return cells

## Draws multiple tiles with the given [param thread] and brush [param size],
## within [param bounding_rect].
func draw_stitch(thread: XStitchThread, center: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var cells = get_brush_area(center, size)
	for cell in cells:
		if bounding_rect.has_point(cell):
			draw_cell(cell, thread)

## Erases multiple tiles, similar to [method draw_stitch].
func erase_stitch(cell: Vector2i, bounding_rect: Rect2i, size: int) -> void:
	var cells = get_brush_area(cell, size)
	for c in cells:
		if bounding_rect.has_point(c):
			erase_cell(c)

## Erases all cells.
func erase_all() -> void:
	for cell in get_used_cells():
		erase_cell(cell)

## Draws a single tile.[br]
## Drawing with this thread for the first time, adds it to 
## the [member _modulated_tile_cache].
func draw_cell(cell: Vector2i, thread: XStitchThread, tile: Vector2i = CURSOR_TILE) -> void:
	if thread == null:
		set_cell(cell, 0, tile)
		return
	
	if thread in _modulated_tile_cache:
		set_cell(cell, 0, tile, _modulated_tile_cache[thread])
		return
	
	# Create an alternative tile, and modify the tile data,
	# so that all tiles are modulated.
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var alt_tile_id := source.create_alternative_tile(tile)
	var tile_data := source.get_tile_data(tile, alt_tile_id)
	tile_data.modulate = thread.color
	_modulated_tile_cache[thread] = alt_tile_id
	set_cell(cell, 0, tile, alt_tile_id)

## Erases all tiles that were drawn with the [param thread].
## Returns the erased cell positions.
func erase_with_thread(thread: XStitchThread) -> Array[Vector2i]:
	var used_cells : Array[Vector2i]
	
	# If the cache contains this thread, get all cells that use it,
	# and erase them. Then erase the thread from the cache.
	if _modulated_tile_cache.has(thread):
		var alt_id = _modulated_tile_cache[thread]
		used_cells = get_used_cells_by_id(0, CURSOR_TILE, alt_id)
		for cell in used_cells:
			erase_cell(cell)
		_modulated_tile_cache.erase(thread)
	
	return used_cells

## Draws multiple tiles based on the given context.
func add_stitches(thread: XStitchThread, context: Array[Vector2i]):
	for cell in context:
		draw_cell(cell, thread)


## Returns a contiguous area from a starting point.
## A contiguous area is a set of neighboring cells that are the same color.
func get_contiguous_area(start: Vector2i, is_in_boundary: Callable) -> Array[Vector2i]:
	var result: Array[Vector2i] # The resulting area
	var thread = get_stitch_at(start) # The thread at the starting point
	var visited: Dictionary[Vector2i, bool] # Keeps track of visited cells
	var frontier: Array[Vector2i] # The working array. Cells are added and removed to this
	
	frontier.push_front(start)
	while !frontier.is_empty():
		var cell = frontier.pop_back()
		# If this cell has been visited, skip it
		if visited.has(cell):
			continue
		visited.get_or_add(cell, true)
		
		# If it's out of bounds, skip it
		if !is_in_boundary.call(cell):
			continue
		
		# If it doesn't have the same thread, skip it
		if get_stitch_at(cell) != thread:
			continue
		
		# All checks passed.
		#  - Add to results
		#  - Add neighbors to frontier
		result.append(cell)
		frontier.append_array(Extensions.get_neighbor_cells(self, cell))
		
	return result


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
