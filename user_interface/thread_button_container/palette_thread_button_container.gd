extends ThreadButtonContainer

## A container for [ThreadButton]s added to the palette.

## Overridden from [method ThreadButtonContainer.create_thread_button],
## so it adds the appropriate context menu as well.
func create_thread_button(thread: XStitchThread) -> ThreadButton:
	var btn = super.create_thread_button(thread)
	btn.set_context_menu(%ThreadContextMenu)
	return btn

## Selects a single button assigned to [param thread].
func select_thread(thread: XStitchThread) -> void:
	if thread != null:
		var btn = thread_button_dictionary.get(thread)
		btn.set_pressed_no_signal(true)

## Deletes the button assigned to [param thread]
## and removes its entry from the dictionary.
func remove_thread(thread: XStitchThread) -> void:
	var btn = thread_button_dictionary.get(thread)
	btn.queue_free()
	thread_button_dictionary.erase(thread)
