@icon("res://icons/thread_green.svg")
class_name ThreadButtonContainer
extends Container

## A container for [ThreadButton]s. Populates and manages array of children
## based on thread data it receives. Can be searched and filtered by
## [member XStitchThread.id] or [member XStitchThread.color_name].

## The thread button scene to instantiate. The container will be
## populated with these buttons.
@export var thread_button: PackedScene

## The thread data.
var threads: Array[XStitchThread]:
	set = set_threads

## Array of buttons managed by this container.
var _created_buttons: Array[ThreadButton]

func _ready() -> void:
	threads = ThreadsAtlas.get_all_threads()

## Sets the [member threads] value.
func set_threads(value: Array[XStitchThread]) -> void:
	threads = value
	reset_buttons()

## Deletes all created buttons, recreates them based on the contents of [member threads]
## and adds them to [member _created_buttons].
func reset_buttons() -> void:
	# Delete all current buttons
	for btn in _created_buttons:
		btn.queue_free()
	
	# Clear array
	_created_buttons.clear()
	
	# For each thread, create a button and add to array
	for t in threads:
		var btn = create_thread_button(t)
		_created_buttons.append(btn)

## Creates a [ThreadButton] associated with an [XStitchThread].
func create_thread_button(thread: XStitchThread) -> ThreadButton:
	var btn = thread_button.instantiate() as ThreadButton
	add_child(btn)
	btn.set_thread(thread)
	return btn

## When the search bar contents change, filters buttons based on if their
## [XStitchThread] matches the contents.
func _on_search_bar_text_changed(new_text: String) -> void:
	# Get text contents
	new_text = new_text.strip_edges().to_lower()
	
	# If empty, show all entries
	if new_text.is_empty():
		for btn in _created_buttons:
			btn.show()
		return
	
	# If not empty, filter own array for matching threads
	var matching_threads = threads.filter(
		func(t): return _search_matches_thread(new_text, t)
	)
	
	# Show buttons associated with matching threads and hide the rest
	for btn in _created_buttons:
		if btn.thread in matching_threads:
			btn.show()
		else:
			btn.hide()

## Returns true if [param thread] partially contains [param text] in its name or ID.
func _search_matches_thread(text: String, thread: XStitchThread) -> bool:
	text = text.to_lower()
	var id := thread.id.to_lower()
	var color_name := thread.color_name.to_lower()
	return id.contains(text) or color_name.contains(text)

## Adds a single thread to the [member threads] array, and appends the corresponding button.
func add_thread(thread: XStitchThread):
	threads.append(thread)
	var btn = create_thread_button(thread)
	_created_buttons.append(btn)

## Selects a single button assigned to [param thread].
func select_thread(thread: XStitchThread):
	for btn in _created_buttons:
		if btn.thread == thread:
			btn.set_pressed_no_signal(true)

## Removes the thread from [member threads] and deletes the button.
func remove_thread(thread: XStitchThread):
	threads.erase(thread)
	for btn in _created_buttons:
		if btn.thread == thread:
			_created_buttons.erase(btn)
			btn.queue_free()
			break
