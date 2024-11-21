class_name SwapThreadCommand
extends Command

var old_thread: Skein
var new_thread: Skein
var palette: Palette

func execute():
	palette.swap_skein(old_thread, new_thread)

func undo():
	palette.swap_skein(new_thread, old_thread)
