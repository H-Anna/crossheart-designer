class_name SelectThreadCommand
extends Command

var palette: Palette
var _last_selected: Skein
var selected: Skein

func execute():
	palette.select_skein(selected)

func undo():
	palette.select_skein(_last_selected)
