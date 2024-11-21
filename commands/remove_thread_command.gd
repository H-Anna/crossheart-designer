class_name RemoveThreadCommand
extends Command

var thread: Skein
var palette: Palette
var _was_selected: bool

func execute():
	_was_selected = palette.selected_thread == thread
	palette.remove_skein(thread)

func undo():
	palette.add_skein(thread)
	if _was_selected:
		palette.selected_thread = thread
