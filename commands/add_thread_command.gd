class_name AddThreadCommand
extends Command

var thread: XStitchThread
#var palette: PaletteModel
var palette_controller: PaletteController

func execute():
	#palette.add_thread(thread)
	palette_controller.add_thread(thread)
	palette_controller.select_thread(thread)

func undo():
	#palette.remove_thread(thread)
	palette_controller.remove_thread(thread)
