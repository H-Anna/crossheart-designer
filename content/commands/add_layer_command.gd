class_name AddLayerCommand
extends Command

## Command that adds a new layer.

## The layer to add.
var layer : XStitchMasterLayer = null

## Adds a layer through the [XStitchCanvas].
func execute() -> void:
	layer = Globals.canvas.add_layer(layer)

## Removes the layer from the [XStitchCanvas]. The layer is kept in memory,
## in case [method execute()] runs again. 
func undo() -> void:
	Globals.canvas.remove_layer(layer)
