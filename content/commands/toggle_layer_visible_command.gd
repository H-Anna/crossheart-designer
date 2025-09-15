class_name ToggleLayerVisibleCommand
extends Command

var layer : XStitchMasterLayer
var button : LayerButton

func execute():
	layer.visible = !layer.visible
	button.update_visibility_button()

func undo():
	layer.visible = !layer.visible
	button.update_visibility_button()
