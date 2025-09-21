class_name RemoveLayerCommand
extends Command

## Command to remove a layer.

## Layer to remove.
var layer : XStitchMasterLayer

## Removes the layer. (This doesn't free the node.)
func execute() -> void:
	Globals.canvas.remove_layer(layer)

## Adds the layer back.
func undo() -> void:
	Globals.canvas.add_layer(layer)
