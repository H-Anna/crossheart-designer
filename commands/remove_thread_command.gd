class_name RemoveThreadCommand
extends Command

var thread: XStitchThread
var palette: PaletteModel
var palette_controller: PaletteController
var _was_selected: bool

func execute():
	_was_selected = palette.selected_thread == thread
	#palette.remove_thread(thread)
	palette_controller.remove_thread(thread)

func undo():
	#palette.add_thread(thread)
	palette_controller.add_thread(thread)
	if _was_selected:
		palette.selected_thread = thread
