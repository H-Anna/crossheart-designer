class_name Canvas
extends Node2D

@onready var camera := $Camera2D
var cursor : Node2D

@export var layer_scene : PackedScene
@export var background_layer : TileMapLayer
@export var stitch_layers_group : Node2D

var canvas_rect: Rect2i

signal canvas_size_changed(new_rect: Rect2i)

func _ready() -> void:
	SignalBus.current_snapshot_changed.connect(deserialize)
	cursor = $Cursor

func create_canvas(rect: Rect2i):
	canvas_rect = rect
	background_layer.clear()
	for x in range(canvas_rect.position.x, canvas_rect.size.x):
		for y in range(canvas_rect.position.y, canvas_rect.size.y):
			background_layer.set_cell(Vector2i(x,y), 0, Vector2i(0,0))
	canvas_size_changed.emit(background_layer.get_used_rect())
	
	delete_all_layers()
	create_layer()
	SignalBus.canvas_changed.emit(self)

func delete_all_layers():
	for i in stitch_layers_group.get_children():
		i.queue_free()
	#SignalBus.canvas_changed.emit(self)

func create_layer() -> Node2D:
	var layer = layer_scene.instantiate()
	stitch_layers_group.add_child(layer)
	layer.owner = stitch_layers_group
	layer.initialize(cursor, canvas_rect)
	#SignalBus.canvas_changed.emit(self)
	return layer

func serialize() -> Dictionary:
	var dict : Dictionary
	dict.get_or_add("size_x", canvas_rect.size.x)
	dict.get_or_add("size_y", canvas_rect.size.y)
	dict.get_or_add("layers", get_layer_order())
	return dict

func deserialize(snapshot: Snapshot):
	var dict = snapshot.state
	var canvas_data = dict["canvas"]
	#var layers_data = dict["layers"]
	
	# Restore canvas size
	var pos = canvas_rect.position
	var size = Vector2i(canvas_data.get("size_x"), canvas_data.get("size_y"))
	var rect = Rect2i(pos, size)
	
	if canvas_rect != rect:
		create_canvas(Rect2i(pos, size))
	
	#Restore layers	
	var layers_data = dict["layers"]
	var layer_nodes = stitch_layers_group.get_children()
	for data in layers_data:
		var matches = layer_nodes.filter(func(node): return node.name == data["name"])
		var layer
		if matches.is_empty():
			layer = create_layer()
		else:
			layer = matches.front()
		layer.deserialize(data)

func get_layer_order() -> Array:
	return stitch_layers_group.get_children().map(func(node) : return node.name)
