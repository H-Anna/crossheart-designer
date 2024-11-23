class_name AddThreadCommand
extends Command

var thread: XStitchThread
var palette: Palette

func execute():
	palette.add_thread(thread)

func undo():
	palette.remove_thread(thread)
