class_name XStitchCanvas
extends Node2D

## Manages a number of [XStitchMasterLayer]s.

@export var layer_scene : PackedScene
var can_draw := false
var bounding_rect : Rect2i
var active_layer : XStitchMasterLayer

var thread : Skein
var brush_size := 1

var cmd : Command

func _ready() -> void:
	Globals.canvas = self
	
	SignalBus.skein_selected.connect(func(skein): thread = skein)
	SignalBus.palette_ui_changed.connect(func(palette): thread = palette.selected_thread)
	SignalBus.canvas_focus_changed.connect(func(focused): can_draw = focused)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	#SignalBus.thread_layer_added.connect(add_layer)
	SignalBus.layer_selected.connect(select_layer)
	#SignalBus.thread_layer_removed.connect(remove_layer)
	
	bounding_rect = %BackgroundLayer.get_used_rect()
	
	add_layer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_draw || !thread:
		return
	
	_handle_drawing()
	_handle_erase()
	
	if cmd:
		_update_command()

func _handle_drawing():
	if Input.is_action_just_pressed("draw"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			cmd = BrushStrokeCommand.new()
			cmd.layer = active_layer.get_active_sublayer()
			cmd.thread = thread
	elif Input.is_action_just_released("draw"):
		_commit()

func _handle_erase():
	if Input.is_action_just_pressed("erase"):
		cmd = EraseCommand.new()
		cmd.layer = active_layer.get_active_sublayer()
	elif Input.is_action_just_released("erase"):
		_commit()

func _commit():
	if cmd:
		SignalBus.command_created.emit(cmd)
		cmd = null

func _update_command():
	var point = cmd.layer.get_mouse_position()
	if cmd is BrushStrokeCommand:
		var pixels = cmd.layer.get_brush_area(point, brush_size)
		for pixel in pixels:
			cmd.pixels_to_draw.get_or_add(pixel, cmd.layer.CURSOR_TILE)
	if cmd is EraseCommand:
		var pixels = cmd.layer.get_brush_area(point, brush_size)
		for pixel in pixels:
			cmd.pixels_to_erase.get_or_add(pixel, cmd.layer.CURSOR_TILE)

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
