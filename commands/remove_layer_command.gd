class_name RemoveLayerCommand
extends Command

var layer : XStitchMasterLayer
var button : LayerButton

func execute():
	Globals.canvas.remove_layer(layer)
	button.hide()

func undo():
	Globals.canvas.add_layer(layer)
	button.show()
