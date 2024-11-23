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

## The currently selected thread.
var thread : Skein

## The current brush size.
var brush_size := 1

## The stored command.
var _cmd : Command

func _ready() -> void:
	Globals.canvas = self
	
	SignalBus.skein_selected.connect(func(skein): thread = skein)
	SignalBus.palette_ui_changed.connect(func(palette): thread = palette.selected_thread)
	SignalBus.canvas_focus_changed.connect(func(focused): can_draw = focused)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	SignalBus.layer_selected.connect(select_layer)
	
	bounding_rect = %BackgroundLayer.get_used_rect()
	
	add_layer()

func _process(delta: float) -> void:
	if !can_draw || !thread:
		return
	
	_handle_drawing()
	_handle_erase()
	
	if _cmd:
		_update_command()

func _handle_drawing():
	if Input.is_action_just_pressed("draw"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			_cmd = BrushStrokeCommand.new()
			_cmd.layer = active_layer.get_active_sublayer()
			_cmd.thread = thread
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
		var pixels = _cmd.layer.get_brush_area(point, brush_size)
		for pixel in pixels:
			_cmd.pixels_to_draw.get_or_add(pixel, _cmd.layer.CURSOR_TILE)
			_cmd.layer.draw_pixel(thread, pixel)
	if _cmd is EraseCommand:
		var pixels = _cmd.layer.get_brush_area(point, brush_size)
		for pixel in pixels:
			_cmd.pixels_to_erase.get_or_add(pixel, _cmd.layer.CURSOR_TILE)
			_cmd.layer.erase_pixel(pixel)

func add_layer(layer: XStitchMasterLayer = null) -> XStitchMasterLayer:
	if !layer:
		layer = layer_scene.instantiate() as XStitchMasterLayer
	%LayersContainer.add_child(layer)
	layer.name = layer.id
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
		active_layer = %LayersContainer.get_child(idx % %LayersContainer.get_child_count())
	SignalBus.layer_removed.emit(layer)
