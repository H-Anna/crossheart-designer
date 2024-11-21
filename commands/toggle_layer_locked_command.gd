class_name ToggleLayerLockedCommand
extends Command

var layer : XStitchMasterLayer
var button : LayerButton

func execute():
	layer.locked = !layer.locked
	button.update_lock_button()

func undo():
	layer.locked = !layer.locked
	button.update_lock_button()
