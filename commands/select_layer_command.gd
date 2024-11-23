class_name SelectLayerCommand
extends Command

var canvas: XStitchCanvas
var selected: XStitchMasterLayer
var _last_selected: XStitchMasterLayer

func execute():
	canvas.select_layer(selected)

func undo():
	canvas.select_layer(_last_selected)
