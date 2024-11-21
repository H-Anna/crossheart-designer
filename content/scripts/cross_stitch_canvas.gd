class_name XStitchCanvas
extends Node2D

## Manages a number of [XStitchMasterLayer]s.

@export var layer_scene : PackedScene
var can_draw := true
var bounding_rect : Rect2i
var active_layer : XStitchMasterLayer

var thread : Skein
var brush_size := 1

func _ready() -> void:
	SignalBus.skein_selected.connect(func(skein): thread = skein)
	SignalBus.palette_ui_changed.connect(func(palette): thread = palette.selected_thread)
	SignalBus.canvas_focus_changed.connect(func(focused): can_draw = focused)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	SignalBus.thread_layer_added.connect(add_layer)
	SignalBus.thread_layer_selected.connect(select_layer)
	SignalBus.thread_layer_removed.connect(remove_layer)
	
	bounding_rect = %BackgroundLayer.get_used_rect()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_draw:
		return
	
	if Input.is_action_pressed("draw", true):
		active_layer.draw_stitch(thread, brush_size, bounding_rect)
	
	if Input.is_action_pressed("erase", true):
		active_layer.erase_stitch(brush_size, bounding_rect)

func add_layer(data: ThreadLayer) -> void:
	var layer = layer_scene.instantiate() as XStitchMasterLayer
	%LayersContainer.add_child(layer)
	layer.data = data
	data.master_layer = layer
	layer.name = data.id
	if data.active:
		active_layer = layer

func select_layer(data: ThreadLayer) -> void:
	active_layer.data.active = false
	active_layer = data.master_layer

func remove_layer(data: ThreadLayer) -> void:
	data.master_layer.queue_free()
	data.master_layer = null
