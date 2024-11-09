extends Control

@export var canvas_scene: PackedScene

func _ready() -> void:
	%LayersContainer.add_layer()
	if (canvas_scene):
		var canvas = canvas_scene.instantiate()
		%CanvasViewport.add_child(canvas)
