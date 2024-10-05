extends TileMapLayer

var cursor : Node2D
var bounding_rect : Rect2i

const cursor_tile := Vector2i(0,0)

var _modulated_tile_cache: Dictionary
var _is_dirty = false

func _ready() -> void:
	SignalBus.skein_removed_from_palette.connect(_erase_cells_with_skein)
	SignalBus.skein_swapped.connect(_swap_cells_with_skein)

func _input(event: InputEvent) -> void:
	if !cursor || cursor.active_skein == null:
		return
	
	execute_cursor_action()
	
	if event is InputEventMouseButton:
		if _is_dirty && event.pressed == false && (event.button_index == MOUSE_BUTTON_LEFT || event.button_index == MOUSE_BUTTON_RIGHT):
			SignalBus.layer_changed.emit(self)
			_is_dirty = false

func _enter_tree() -> void:
	SignalBus.layer_added.emit(self)

func _exit_tree() -> void:
	SignalBus.layer_removed.emit(self)

func initialize(_cursor: Node2D, _rect : Rect2i) -> void:
	cursor = _cursor
	bounding_rect = _rect

func execute_cursor_action() -> void:
	match cursor.tool_mode:
		Helpers.ToolMode.DRAW:
			var current_cell = local_to_map(cursor.cursor_position)
			_draw_with_cursor(current_cell, cursor.cursor_size, 1)
		Helpers.ToolMode.ERASE:
			var current_cell = local_to_map(cursor.cursor_position)
			_erase_with_cursor(current_cell, cursor.cursor_size, 1)
		_:
			pass

## Recursive function to draw pixels up to the brush size.
func _draw_with_cursor(cell: Vector2i, depth: int, current_depth : int) -> void:
	if current_depth > depth:
		return
	
	if Extensions.vector2i_is_within_rect2i(cell, bounding_rect):
		_set_cell_modulated(cell, cursor.active_skein)
		_is_dirty = true
	
	for neighbor in Extensions.get_neighbor_cells(self, cell):
		_draw_with_cursor(neighbor, depth, current_depth + 1)

## Recursive function to erase pixels up to the brush size.
func _erase_with_cursor(cell: Vector2i, depth: int, current_depth : int) -> void:
	if current_depth > depth:
		return
	
	if Extensions.vector2i_is_within_rect2i(cell, bounding_rect):
		erase_cell(cell)
		_is_dirty = true
	
	for neighbor in Extensions.get_neighbor_cells(self, cell):
		_erase_with_cursor(neighbor, depth, current_depth + 1)

func _set_cell_modulated(cell: Vector2i, skein: Skein) -> void:
	if skein == null:
		set_cell(cell, 0, cursor_tile)
		return
	
	if skein in _modulated_tile_cache:
		set_cell(cell, 0, cursor_tile, _modulated_tile_cache[skein])
		return
	
	var source := tile_set.get_source(0) as TileSetAtlasSource
	var alt_tile_id := source.create_alternative_tile(cursor_tile)
	var tile_data := source.get_tile_data(cursor_tile, alt_tile_id)
	tile_data.modulate = skein.color
	_modulated_tile_cache[skein] = alt_tile_id
	set_cell(cell, 0, cursor_tile, alt_tile_id)

func _erase_cells_with_skein(skein: Skein):
	if _modulated_tile_cache.has(skein):
		var alt_id = _modulated_tile_cache[skein]
		for cell in get_used_cells_by_id(0, cursor_tile, alt_id):
			erase_cell(cell)
		_modulated_tile_cache.erase(skein)
		SignalBus.layer_changed.emit(self, false)

func _swap_cells_with_skein(old_skein: Skein, new_skein: Skein):
	if !_modulated_tile_cache.has(old_skein):
		return
	
	var old_alt_id = _modulated_tile_cache[old_skein]
	for cell in get_used_cells_by_id(0, cursor_tile, old_alt_id):
		_set_cell_modulated(cell, new_skein)
	
	SignalBus.layer_changed.emit(self, false)

func serialize() -> Dictionary:
	var tiles_arr: Array[Dictionary]
	for skein in _modulated_tile_cache:
		var skein_dict: Dictionary
		var alt_id = _modulated_tile_cache[skein]
		skein_dict.get_or_add("skein_global_id", skein.get_identifying_name())
		skein_dict.get_or_add("coordinates", get_used_cells_by_id(0, cursor_tile, alt_id))
		tiles_arr.append(skein_dict)
	
	var dict: Dictionary
	dict.get_or_add("name", name)
	dict.get_or_add("tiles", tiles_arr)
	return dict

func deserialize(dict: Dictionary):
	name = dict["name"]
	clear()
	for tiles_collection in dict["tiles"]:
		## TODO: get skein by global id
		var id = tiles_collection["skein_global_id"]
		var skein = SkeinsAtlas.get_skein_by_global_id(id)
		for cell in tiles_collection["coordinates"]:
			_set_cell_modulated(cell, skein)
