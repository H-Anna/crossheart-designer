class_name RemoveLayerCommand
extends Command

var layer : XStitchMasterLayer

func execute():
	Globals.canvas.remove_layer(layer)

func undo():
	Globals.canvas.add_layer(layer)
