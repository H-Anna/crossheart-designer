class_name RenameLayerCommand
extends Command

var layer : XStitchMasterLayer
var button : LayerButton
var new_name : String
var _old_name : String

func execute():
	_old_name = layer.display_name
	layer.display_name = new_name
	button.update_display_name()

func undo():
	layer.display_name = _old_name
	button.update_display_name()
