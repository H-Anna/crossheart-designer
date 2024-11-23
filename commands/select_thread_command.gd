class_name SelectThreadCommand
extends Command

var palette: Palette
var _last_selected: XStitchThread
var selected: XStitchThread

func execute():
	palette.select_thread(selected)

func undo():
	palette.select_thread(_last_selected)
