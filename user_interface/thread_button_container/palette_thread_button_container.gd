class_name PaletteThreadButtonContainer
extends ThreadButtonContainer

## A container for [ThreadButton]s added to the palette.

func _ready() -> void:
	pass

## Overridden from [method ThreadButtonContainer.create_thread_button],
## so it adds the appropriate context menu as well.
func create_thread_button(thread: XStitchThread) -> ThreadButton:
	var btn = super.create_thread_button(thread)
	btn.set_context_menu(%ThreadContextMenu)
	return btn
