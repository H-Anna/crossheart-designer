extends Control

@export var canvas_scene: PackedScene

func _ready() -> void:
	if (canvas_scene):
		var canvas = canvas_scene.instantiate()
		%CanvasViewport.add_child(canvas)
