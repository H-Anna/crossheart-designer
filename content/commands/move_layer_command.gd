class_name MoveLayerCommand
extends Command

## Moves the layer higher or lower in the layer order.

## The positions to move this layer. Positive integer means the layer
## is moved towards the top, negative means it is moved toward the bottom.
var move : int

## The layer to move.
var layer : XStitchMasterLayer

## The [LayerButton] associated with the layer.
var button : LayerButton

## Moves the layer and the layer button.
## Layer buttons must be moved in the opposite direction as UI drawing order
## in the container is different from regular node drawing order.
func execute() -> void:
	var child_count = Globals.canvas.get_layer_count()
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() + move, 0, child_count - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() - move, 0, child_count - 1)
	button_parent.move_child(button, button_to_idx)

## Undoes the move.
func undo() -> void:
	var child_count = Globals.canvas.get_layer_count()
	var layer_parent = layer.get_parent()
	var layer_to_idx = clampi(layer.get_index() - move, 0, child_count - 1)
	layer_parent.move_child(layer, layer_to_idx)
	
	var button_parent = button.get_parent()
	var button_to_idx = clampi(button.get_index() + move, 0, child_count - 1)
	button_parent.move_child(button, button_to_idx)
