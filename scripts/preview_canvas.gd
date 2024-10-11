class_name PreviewCanvas
extends Canvas

func _ready() -> void:
	pass

func create_canvas(rect: Rect2i, _emit_signals: bool = true):
	super.create_canvas(rect)
	fit_camera_zoom()

func create_layer(_emit_signals: bool = true) -> Node2D:
	var layer = layer_scene.instantiate()
	layers_container.add_child(layer)
	return layer

func fit_camera_zoom():
	##TODO: fit camera zoom
	pass
