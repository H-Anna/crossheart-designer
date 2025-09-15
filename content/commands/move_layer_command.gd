class_name MoveLayerCommand
extends Command

var move : int
var layer : XStitchMasterLayer
var button : LayerButton

func execute():
	var child_count = Globals.canvas.get_layer_count()
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() + move, 0, child_count - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() - move, 0, child_count - 1)
	button_parent.move_child(button, button_to_idx)

func undo():
	var child_count = Globals.canvas.get_layer_count()
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() - move, 0, child_count - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() + move, 0, child_count - 1)
	button_parent.move_child(button, button_to_idx)
