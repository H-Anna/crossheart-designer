class_name XStitchMasterLayer
extends Node2D

## Manages multiple [XStitchDrawingLayer]s. Handles calls from [XStitchCanvas].

var id:
	set(value):
		id = value
		name = value

@onready var layers : Dictionary = {
	"FULL" : %FullStitchLayer,
	#"BACK" : %BackStitchLayer
}

## The name of the layer displayed to the user.
var display_name : String = "New Layer"

## The locked state of the layer.
## Locking or hiding a layer prevents drawing.
var locked : bool = false

## The stored command.
var _cmd : Command

## The size and position of the canvas.
## Used to restrict drawing within the canvas.
var bounding_rect : Rect2i

func _ready() -> void:
	id = Extensions.generate_unique_string()

func is_active():
	return Globals.canvas.active_layer == self

func get_current_cell():
	return get_active_sublayer().get_mouse_position()

func get_active_sublayer() -> XStitchDrawingLayer:
	return %FullStitchLayer #TODO: return based on active tool

func add_stitches(thread: XStitchThread, context: Dictionary):
	for key in layers:
		layers[key].add_stitches(thread, context[key])

func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for key in layers:
		context[key] = layers[key]._erase_cells_with_thread(thread)
	return context

func update_command():
	if !_cmd:
		return
	if _cmd is BrushStrokeCommand:
		update_brush_stroke_command()
	if _cmd is EraseCommand:
		update_erase_command()

func update_brush_stroke_command():
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, _cmd.brush_size)
	for cell in cells.filter(cell_is_in_canvas):
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_draw.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.draw_cell(cell, _cmd.thread)

func create_brush_stroke_command(thread: XStitchThread, brush_size: int):
		_cmd = BrushStrokeCommand.new()
		_cmd.layer = get_active_sublayer()
		_cmd.thread = thread
		_cmd.brush_size = brush_size

func update_erase_command():
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, _cmd.brush_size)
	for cell in cells:
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_erase.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.erase_cell(cell)

func create_erase_command(brush_size: int):
	_cmd = EraseCommand.new()
	_cmd.layer = get_active_sublayer()
	_cmd.brush_size = brush_size

func finalize_command():
	if _cmd:
		SignalBus.command_created.emit(_cmd)
		_cmd = null

func cell_is_in_canvas(p: Vector2i) -> bool:
	if p.x < 0 || p.y < 0:
		return false
	if p.x >= bounding_rect.size.x || p.y >= bounding_rect.size.y:
		return false
	return true

func pick_thread() -> XStitchThread:
	var layer = get_active_sublayer()
	var cell = layer.get_mouse_position()
	return layer.get_stitch_at(cell)

func create_fill_command(thread: XStitchThread):
	var layer = get_active_sublayer()
	var start = layer.get_mouse_position()
	var previous_thread = layer.get_stitch_at(start)
	# Stop immediately if trying to fill a same color area.
	# This prevents filling the command history with junk.
	if previous_thread == thread:
		return
	
	var area = layer.get_contiguous_area(start, cell_is_in_canvas)
	
	_cmd = FillCommand.new()
	_cmd.layer = layer
	_cmd.area = area
	_cmd.previous_thread = previous_thread
	_cmd.thread = thread
	finalize_command()
	pass

func serialize():
	var data = {}
	data.get_or_add("id", id)
	data.get_or_add("display_name", display_name)
	data.get_or_add("visible", visible)
	data.get_or_add("locked", locked)
	data.get_or_add("active", is_active())
	for child in get_children():
		data.get_or_add(child.name, child.serialize())
	return data

func deserialize(data: Dictionary) -> void:
	id = data.get("id", "ERR")
	name = id
	display_name = data.get("display_name")
	visible = data.get("visible", true)
	locked = data.get("locked", false)
	var _active = data.get("active", false)
	if _active:
		Globals.canvas.select_layer(self)
	for child in get_children():
		child.deserialize(data.get(child.name))
