class_name ToggleLayerVisibleCommand
extends Command

## Toggles visible state on a layer.

## Layer to use.
var layer : XStitchMasterLayer

## Layer button controlling that layer.
var button : LayerButton

## Toggles layer visibility and updates the icon on the button.
func execute() -> void:
	layer.visible = !layer.visible
	button.update_visibility_button()

## Restores previous visible state.
func undo() -> void:
	layer.visible = !layer.visible
	button.update_visibility_button()
