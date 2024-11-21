extends Control

@export var canvas_scene: PackedScene

func _ready() -> void:
	var tl = ThreadLayer.new()
	tl.active = true
	SignalBus.thread_layer_added.emit(tl)
