class_name PreviewCanvas
extends Canvas

func _ready() -> void:
	pass

func create_canvas(rect: Rect2i):
	super.create_canvas(rect)
	fit_camera_zoom()

func create_layer() -> Node2D:
	var layer = layer_scene.instantiate()
	stitch_layers_group.add_child(layer)
	return layer

func fit_camera_zoom():
	##TODO: fit camera zoom
	pass
