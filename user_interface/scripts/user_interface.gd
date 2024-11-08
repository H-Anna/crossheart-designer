extends Control

@export var canvas_scene: PackedScene

func _ready() -> void:
	%AddThreadContainer.threads = SkeinsAtlas.get_all_skeins()
	
	if (canvas_scene):
		var canvas = canvas_scene.instantiate()
		%CanvasViewport.add_child(canvas)
