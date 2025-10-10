class_name XStitchMasterLayer
extends Node2D

## Manages multiple [XStitchDrawingLayer]s. Handles calls from [XStitchCanvas].

## The unique ID of the master layer.
var id:
	set(value):
		id = value
		name = value

## The various sublayers managed by this master layer.
@onready var sublayers : Dictionary = {
	"FULL" : %FullStitchLayer,
	"BACK" : %BackStitchLayer
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

## Generates a unique ID for itself.
func _ready() -> void:
	id = Extensions.generate_unique_string()

## Returns true if this is the active layer.
func is_active():
	return Globals.canvas.active_layer == self

## Returns the cell under the mouse pointer.
func get_current_cell() -> Vector2i:
	return get_active_sublayer().get_mouse_position()


## Returns the active sublayer based on the current tool.
func get_active_sublayer(): ##TODO: restore return type
	var tool = Globals.xstitch_tool_controller.get_current_tool()
	match tool.method:
		XStitchTool.Method.BACKSTITCH:
			return %BackStitchLayer
		_:
			return %FullStitchLayer

## Draws multiple stitches to its sublayers with [param thread].
## [param context] contains the sublayers and the positions.
func add_stitches(thread: XStitchThread, context: Dictionary) -> void:
	for key in sublayers:
		sublayers[key].add_stitches(thread, context[key])

## Erases multiple [param thread] stitches from its sublayers.
## Returns the erased positions on each sublayer as context.
func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for key in sublayers:
		context[key] = sublayers[key].erase_with_thread(thread)
	return context

## Updates a command that needs continuous data, such as a
## [BrushStrokeCommand] or [EraseCommand].
func update_command() -> void:
	if !_cmd:
		return
	if _cmd is BrushStrokeCommand:
		update_brush_stroke_command()
	if _cmd is EraseCommand:
		update_erase_command()
	if _cmd is AddBackstitchCommand:
		update_backstitch_draw_command()

## Updates a [BrushStrokeCommand] with cell data.
func update_brush_stroke_command() -> void:
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, _cmd.brush_size)
	for cell in cells.filter(cell_is_in_canvas):
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_draw.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.draw_cell(cell, _cmd.thread)

## Creates a [BrushStrokeCommand].
func create_brush_stroke_command(thread: XStitchThread, brush_size: int) -> void:
		_cmd = BrushStrokeCommand.new()
		_cmd.layer = get_active_sublayer()
		_cmd.thread = thread
		_cmd.brush_size = brush_size

## Updates an [EraseCommand] with cell data.
func update_erase_command() -> void:
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, _cmd.brush_size)
	for cell in cells:
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_erase.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.erase_cell(cell)

## Creates an [EraseCommand].
func create_erase_command(brush_size: int) -> void:
	_cmd = EraseCommand.new()
	_cmd.layer = get_active_sublayer()
	_cmd.brush_size = brush_size

## Sends a finished command.
func finalize_command() -> void:
	if _cmd:
		if _cmd is AddBackstitchCommand:
			_cmd.layer.set_preview_backstitch_visible(false)
			# Command is discarded if line is not rendered
			# TODO: add this method to all other commands?
		
		SignalBus.command_created.emit(_cmd)
		_cmd = null

## Returns true if the given cell position is within the bounding rectangle
## of the canvas.
func cell_is_in_canvas(p: Vector2i) -> bool:
	if p.x < 0 || p.y < 0:
		return false
	if p.x >= bounding_rect.size.x || p.y >= bounding_rect.size.y:
		return false
	return true

## Returns the [XStitchThread] used at the mouse position.
func pick_thread() -> XStitchThread:
	var layer = get_active_sublayer()
	var cell = layer.get_mouse_position()
	return layer.get_stitch_at(cell)

## Creates a [FillCommand], passing it the contiguous area under
## the mouse position.
func create_fill_command(thread: XStitchThread) -> void:
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

## Creates an [AddBackstitchCommand].
func create_backstitch_draw_command(thread: XStitchThread) -> void:
	_cmd = AddBackstitchCommand.new()
	_cmd.layer = get_active_sublayer()
	_cmd.thread = thread
	_cmd.points.push_back(_cmd.layer.get_mouse_position())
	_cmd.points_count = 1
	
	_cmd.layer.set_preview_backstitch_color(_cmd.thread.color)
	_cmd.layer.set_preview_backstitch_points(_cmd.points)
	_cmd.layer.set_preview_backstitch_visible(true)

## Updates an [AddBackstitchCommand] with mouse pointer data.
func update_backstitch_draw_command() -> void:
	var point = _cmd.layer.get_mouse_position()
	if _cmd.points.size() > _cmd.points_count:
		_cmd.points.pop_back()
	_cmd.points.push_back(point)
	_cmd.layer.set_preview_backstitch_points(_cmd.points)

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
