class_name MoveLayerCommand
extends Command

var move : int
var layer : XStitchMasterLayer
var button : LayerButton

func execute():
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() + move, 0, layer_parent.get_child_count() - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() - move, 0, button_parent.get_child_count() - 1)
	button_parent.move_child(button, button_to_idx)

func undo():
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() - move, 0, layer_parent.get_child_count() - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() + move, 0, button_parent.get_child_count() - 1)
	button_parent.move_child(button, button_to_idx)
