class_name PaletteController
extends Node

var palette : PaletteModel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	palette = PaletteModel.new()
