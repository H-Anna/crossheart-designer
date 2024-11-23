class_name SwapThreadCommand
extends Command

var old_thread: XStitchThread
var new_thread: XStitchThread
var palette: Palette

func execute():
	palette.swap_thread(old_thread, new_thread)

func undo():
	palette.swap_thread(new_thread, old_thread)
