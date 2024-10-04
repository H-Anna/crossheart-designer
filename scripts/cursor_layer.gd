extends TileMapLayer

@export var tile : TileSetAtlasSource
@onready var canvas : Canvas = get_parent()
const cursor_tile := Vector2i(0,0)
var active_cell := Vector2i(0,0)

func _ready() -> void:
	SignalBus.focus_changed.connect(_apply_focus_change)

func _input(_event: InputEvent) -> void:
	if %Cursor.active_skein == null:
		return
	
	# Get mouse position on tilemap
	var current_cell = local_to_map(%Cursor.cursor_position)
	
	# De-highlight previous cell
	if active_cell != current_cell:
		_erase_cursor()
		active_cell = current_cell
	
	# Highlight current cell
	_draw_cursor(active_cell, %Cursor.cursor_size, 1)

func _apply_focus_change(mode: int):
	match mode:
		Helpers.MouseFocusMode.DRAWING_AREA: pass
		_: _erase_cursor()

func _draw_cursor(cell: Vector2i, depth: int, current_depth : int) -> void:
	if current_depth > depth:
		return
	if Extensions.vector2i_is_within_rect2i(cell, canvas.canvas_rect):
		set_cell(cell, 0, cursor_tile)
	for neighbor in Extensions.get_neighbor_cells(self, cell):
		_draw_cursor(neighbor, depth, current_depth + 1)

func _erase_cursor() -> void:
	for cell in get_used_cells():
		erase_cell(cell)

func _on_cursor_size_changed(new_size: int) -> void:
	_erase_cursor()
	_draw_cursor(active_cell, new_size, 1)

func _on_cursor_color_changed(new_color: Color) -> void:
	self_modulate = new_color
