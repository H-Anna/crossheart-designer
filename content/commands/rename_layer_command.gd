class_name RenameLayerCommand
extends Command

## Command to rename a layer. Renaming only applies to
## [member XStitchMasterLayer.display_name] and doesn't change 
## the node's name.

## Layer to rename.
var layer : XStitchMasterLayer

## Layer button controlling the layer.
var button : LayerButton

## The new layer name.
var new_name : String

## The previous layer name.
var _old_name : String

## Renames the layer.
func execute() -> void:
	if _old_name.is_empty():
		_old_name = layer.display_name
	layer.display_name = new_name
	button.update_display_name()

## Sets the layer name back to the original.
func undo() -> void:
	layer.display_name = _old_name
	button.update_display_name()
