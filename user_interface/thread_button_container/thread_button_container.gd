@icon("res://icons/thread_green.svg")
class_name ThreadButtonContainer
extends Container

## A container for [ThreadButton]s. Populates and manages array of children
## based on thread data it receives. Can be searched and filtered by
## [member XStitchThread.id] or [member XStitchThread.color_name].

## The thread button scene to instantiate. The container will be
## populated with these buttons.
@export var thread_button: PackedScene

## A dictionary that stores threads and the associated thread buttons.
var thread_button_dictionary: Dictionary[XStitchThread, ThreadButton]


## Sets the [member threads] value. Deletes all buttons and recreates them.
func set_threads(threads: Array[XStitchThread]) -> void:
	for key in thread_button_dictionary:
		thread_button_dictionary[key].queue_free()
	
	thread_button_dictionary.clear()
	
	for t in threads:
		add_thread(t)


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
		for btn in thread_button_dictionary.values():
			btn.show()
		return
	
	# If not empty, filter own array for matching threads
	var matching_threads = thread_button_dictionary.keys().filter(
		func(t): return _search_matches_thread(new_text, t)
	)
	
	# Show buttons associated with matching threads and hide the rest
	for btn in thread_button_dictionary.values():
		btn.hide()
	
	for thread in matching_threads:
		thread_button_dictionary[thread].show()


## Returns true if [param thread] partially contains [param text] in its name or ID.
func _search_matches_thread(text: String, thread: XStitchThread) -> bool:
	text = text.to_lower()
	var id := thread.id.to_lower()
	var color_name := thread.color_name.to_lower()
	return id.contains(text) or color_name.contains(text)


## Adds a thread to the dictionary, and the corresponding button to the scene.
func add_thread(thread: XStitchThread) -> void:
	var btn = create_thread_button(thread)
	thread_button_dictionary.set(thread, btn)
