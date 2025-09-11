class_name XStitchCanvas
extends Node2D

## Manages a number of [XStitchMasterLayer]s.

## Layer scene to instantiate.
@export var layer_scene : PackedScene

## Whether the canvas can be drawn on.
var can_draw := false

## The size and position of the canvas.
## Used to restrict drawing within the canvas.
var bounding_rect : Rect2i

## The layer currently being drawn on.
var active_layer : XStitchMasterLayer

## The current brush size.
var brush_size := 1

## The stored command.
var _cmd : Command

func _ready() -> void:
	Globals.canvas = self
	
	SignalBus.canvas_focus_changed.connect(_focus_changed)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	SignalBus.layer_selected.connect(select_layer)
	
	bounding_rect = %BackgroundLayer.get_used_rect()
	
	add_layer()

func _process(_delta: float) -> void:
	if !can_draw || !get_current_thread():
		return
	
	_handle_drawing()
	_handle_erase()
	
	if _cmd:
		_update_command()

func _focus_changed(focused: bool):
	can_draw = focused
	if !can_draw && _cmd:
		_commit()

func _handle_drawing():
	if Input.is_action_just_pressed("draw"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			_cmd = BrushStrokeCommand.new()
			_cmd.layer = active_layer.get_active_sublayer()
			_cmd.thread = get_current_thread()
	elif Input.is_action_just_released("draw"):
		_commit()

func _handle_erase():
	if Input.is_action_just_pressed("erase"):
		_cmd = EraseCommand.new()
		_cmd.layer = active_layer.get_active_sublayer()
	elif Input.is_action_just_released("erase"):
		_commit()

func _commit():
	if _cmd:
		SignalBus.command_created.emit(_cmd)
		_cmd = null

func _update_command():
	var point = _cmd.layer.get_mouse_position()
	if _cmd is BrushStrokeCommand:
		var cells = _cmd.layer.get_brush_area(point, brush_size)
		for cell in cells.filter(cell_is_in_canvas):
			_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
			_cmd.cells_to_draw.get_or_add(cell, _cmd.layer.CURSOR_TILE)
			_cmd.layer.draw_cell(cell, get_current_thread())
	if _cmd is EraseCommand:
		var cells = _cmd.layer.get_brush_area(point, brush_size)
		for cell in cells:
			_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
			_cmd.cells_to_erase.get_or_add(cell, _cmd.layer.CURSOR_TILE)
			_cmd.layer.erase_cell(cell)

func add_layer(layer: XStitchMasterLayer = null) -> XStitchMasterLayer:
	if !layer:
		layer = layer_scene.instantiate() as XStitchMasterLayer
	%LayersContainer.add_child(layer)
	if !active_layer:
		active_layer = layer
		
	SignalBus.layer_added.emit(layer)
	return layer

func select_layer(layer: XStitchMasterLayer) -> void:
	active_layer = layer

func remove_layer(layer: XStitchMasterLayer) -> void:
	var idx = layer.get_index()
	var active = layer.is_active()
	%LayersContainer.remove_child(layer)
	if active:
		active_layer = %LayersContainer.get_child(idx % get_layer_count())
	SignalBus.layer_removed.emit(layer)

func cell_is_in_canvas(p: Vector2i) -> bool:
	if p.x < 0 || p.y < 0:
		return false
	if p.x >= bounding_rect.size.x || p.y >= bounding_rect.size.y:
		return false
	return true

func get_current_thread():
	return %PaletteController.get_selected_thread()

func add_stitches(thread: XStitchThread, context: Dictionary):
	for master_layer in %LayersContainer.get_children():
		master_layer.add_stitches(thread, context[master_layer.name])
	pass

func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for master_layer in %LayersContainer.get_children():
		context[master_layer.name] = master_layer.remove_stitches(thread)
	return context

func get_layer_count():
	return $LayersContainer.get_child_count()

func serialize():
	var data = {}
	
	data.get_or_add("size_x", bounding_rect.size.x)
	data.get_or_add("size_y", bounding_rect.size.y)
	
	var layers = []
	for child in %LayersContainer.get_children():
		layers.append(child.serialize())
	
	data.get_or_add("layers", layers)
	return data

func deserialize(data: Dictionary):
	active_layer = null
	for layer in %LayersContainer.get_children():
		remove_layer(layer)
	
	var size_x = data["size_x"]
	var size_y = data["size_y"]
	bounding_rect = Rect2i(0, 0, size_x, size_y)
	
	for layer in data["layers"]:
		var child = layer_scene.instantiate() as XStitchMasterLayer
		child.deserialize(layer)
		add_layer(child)
