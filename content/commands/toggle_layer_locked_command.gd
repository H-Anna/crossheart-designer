class_name ToggleLayerLockedCommand
extends Command

## Toggles locked state on a layer.

## Layer to use.
var layer : XStitchMasterLayer

## Layer button controlling that layer.
var button : LayerButton

## Toggles layer lock and updates the icon on the button.
func execute() -> void:
	layer.locked = !layer.locked
	button.update_lock_button()

## Restores previous locked state.
func undo() -> void:
	layer.locked = !layer.locked
	button.update_lock_button()
