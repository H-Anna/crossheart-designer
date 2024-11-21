class_name AddLayerCommand
extends Command

var _layer : XStitchMasterLayer = null

func execute():
	_layer = Globals.canvas.add_layer(_layer)

func undo():
	Globals.canvas.remove_layer(_layer)
