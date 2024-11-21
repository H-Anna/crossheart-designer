class_name AddThreadCommand
extends Command

var thread: Skein
var palette: Palette

func execute():
	palette.add_skein(thread)

func undo():
	palette.remove_skein(thread)
