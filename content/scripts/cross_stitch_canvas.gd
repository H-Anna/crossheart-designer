class_name XStitchCanvas
extends Node2D

var can_draw := true
var active_layer : XStitchMasterLayer
var bounding_rect : Rect2i

var cursor_thread : Skein
var cursor_size := 1

func _ready() -> void:
	SignalBus.skein_selected.connect(func(skein): cursor_thread = skein)
	SignalBus.canvas_focus_changed.connect(func(focused): can_draw = focused)
	
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
		active_layer.draw_stitch(cursor_thread, cursor_size, bounding_rect)
	if Input.is_action_pressed("erase", true):
		active_layer.erase_stitch(cursor_size, bounding_rect)
	if Input.is_action_just_pressed("increase-brush-size", true):
		cursor_size += 1
	if Input.is_action_just_pressed("decrease-brush-size", true):
		cursor_size -= 1
