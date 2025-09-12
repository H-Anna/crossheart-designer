class_name XStitchCanvas
extends Node2D

## Manages a number of [XStitchMasterLayer]s.

## Layer scene to instantiate.
@export var layer_scene : PackedScene
## The UI element that contains LayerButtons.
@export var ui_layer_button_container : LayerButtonContainer

## Whether the canvas has GUI input focus.
var focused := false

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
	
	# TODO: ability for custom size or resize canvas
	bounding_rect = $BackgroundLayer.get_used_rect()
	
	add_layer()


func _unhandled_input(event: InputEvent) -> void:
	if !accepts_input():
		return
	
	handle_draw_input(event)
	
	handle_erase_input(event)
	pass


func handle_draw_input(event: InputEvent):
	## Starting brush stroke
	if event.is_action_pressed("draw"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			brush_stroke_command()
	
	if event is InputEventMouseMotion && _cmd is BrushStrokeCommand:
		update_brush_stroke()
	
	## Ending brush stroke
	if event.is_action_released("draw"):
		finalize_command()

func update_brush_stroke():
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, brush_size)
	for cell in cells.filter(cell_is_in_canvas):
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_draw.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.draw_cell(cell, get_current_thread())

func brush_stroke_command():
		_cmd = BrushStrokeCommand.new()
		_cmd.layer = active_layer.get_active_sublayer()
		_cmd.thread = get_current_thread()

func handle_erase_input(event: InputEvent):
	if event.is_action_pressed("erase"):
		print("Erasing start!")
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			erase_command()
	
	if event is InputEventMouseMotion && _cmd is EraseCommand:
		update_erase()
	
	if event.is_action_released("erase"):
		print("Erasing ended!")
		finalize_command()

func update_erase():
	var point = _cmd.layer.get_mouse_position()
	var cells = _cmd.layer.get_brush_area(point, brush_size)
	for cell in cells:
		_cmd.previous_stitches.get_or_add(cell, _cmd.layer.get_stitch_at(cell))
		_cmd.cells_to_erase.get_or_add(cell, _cmd.layer.CURSOR_TILE)
		_cmd.layer.erase_cell(cell)

func erase_command():
	_cmd = EraseCommand.new()
	_cmd.layer = active_layer.get_active_sublayer()

func finalize_command():
	if _cmd:
		SignalBus.command_created.emit(_cmd)
		_cmd = null


func _focus_changed(_focused: bool):
	focused = _focused
	if !focused && _cmd:
		finalize_command()


func add_layer(layer: XStitchMasterLayer = null) -> XStitchMasterLayer:
	if !layer:
		layer = layer_scene.instantiate() as XStitchMasterLayer
	$LayersContainer.add_child(layer)
	
	if !active_layer:
		select_layer(layer)
		
	ui_layer_button_container.add_layer(layer)
	return layer

func select_layer(layer: XStitchMasterLayer) -> void:
	active_layer = layer

func remove_layer(layer: XStitchMasterLayer) -> void:
	if layer.is_active():
		var idx = layer.get_index()
		var next_layer = $LayersContainer.get_child((idx + 1) % get_layer_count())
		select_layer(next_layer)
	
	$LayersContainer.remove_child(layer)
	ui_layer_button_container.remove_layer(layer)

func cell_is_in_canvas(p: Vector2i) -> bool:
	if p.x < 0 || p.y < 0:
		return false
	if p.x >= bounding_rect.size.x || p.y >= bounding_rect.size.y:
		return false
	return true

func get_current_thread():
	return %PaletteController.get_selected_thread()

func add_stitches(thread: XStitchThread, context: Dictionary):
	for master_layer in $LayersContainer.get_children():
		master_layer.add_stitches(thread, context[master_layer.name])
	pass

func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for master_layer in $LayersContainer.get_children():
		context[master_layer.name] = master_layer.remove_stitches(thread)
	return context

func get_layer_count():
	return $LayersContainer.get_child_count()

func accepts_input():
	return focused && get_current_thread()

func serialize():
	var data = {}
	
	data.get_or_add("size_x", bounding_rect.size.x)
	data.get_or_add("size_y", bounding_rect.size.y)
	
	var layers = []
	for child in $LayersContainer.get_children():
		layers.append(child.serialize())
	
	data.get_or_add("layers", layers)
	return data

func deserialize(data: Dictionary):
	active_layer = null
	for layer in $LayersContainer.get_children():
		remove_layer(layer)
	
	var size_x = data["size_x"]
	var size_y = data["size_y"]
	bounding_rect = Rect2i(0, 0, size_x, size_y)
	
	for layer in data["layers"]:
		var child = layer_scene.instantiate() as XStitchMasterLayer
		child.deserialize(layer)
		add_layer(child)
