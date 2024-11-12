class_name XStitchCanvas
extends Node2D

@export var layer_scene : PackedScene
var can_draw := true
var bounding_rect : Rect2i
var active_layer : XStitchMasterLayer

var thread : Skein
var brush_size := 1

func _ready() -> void:
	SignalBus.skein_selected.connect(func(skein): thread = skein)
	SignalBus.skein_swapped.connect(func(old, new): thread = new)
	SignalBus.canvas_focus_changed.connect(func(focused): can_draw = focused)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	bounding_rect = %BackgroundLayer.get_used_rect()
	
	for layer in get_tree().get_nodes_in_group("master_layers"):
		if !active_layer:
			layer.active = true
			active_layer = layer
		else:
			layer.active = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !can_draw:
		return
	
	if Input.is_action_pressed("draw", true):
		active_layer.draw_stitch(thread, brush_size, bounding_rect)
	
	if Input.is_action_pressed("erase", true):
		active_layer.erase_stitch(brush_size, bounding_rect)

func add_layer() -> void:
	var data = ThreadLayer.new()
	var layer = layer_scene.instantiate() as XStitchMasterLayer
	%LayersContainer.add_child(layer)
	layer.data = data
