## A container for thread buttons. Populates and manages array of children
## based on thread data it receives.
@icon("res://icons/ThreadButtonContainer.svg")
class_name ThreadButtonContainer
extends Container

## The thread button scene to instantiate. The container will be
## populated with these buttons.
@export var thread_button: PackedScene

## The thread data.
var threads: Array[XStitchThread]:
	set(value):
		threads = value
		_change_threads()

var _created_buttons: Array[ThreadButton]

func _ready() -> void:
	threads = ThreadsAtlas.get_all_threads()

func _change_threads() -> void:
	# Delete all current
	for btn in _created_buttons:
		btn.queue_free()
	
	_created_buttons.clear()
	
	for t in threads:
		var btn = thread_button.instantiate() as ThreadButton
		_created_buttons.append(btn)
		add_child(btn)
		btn.thread = t
		btn.pressed.connect(on_thread_button_clicked.bind(btn))

func _on_search_bar_text_changed(new_text: String) -> void:
	# Get text contents
	new_text = new_text.strip_edges().to_lower()
	
	# If empty, show all entries
	if new_text.is_empty():
		for btn in _created_buttons:
			btn.show()
		return
	
	var matching_threads = threads.filter(
		func(t): return _search_matches_thread(new_text, t)
	)
	for btn in _created_buttons:
		if btn.thread in matching_threads:
			btn.show()
		else:
			btn.hide()

func _search_matches_thread(text: String, thread: XStitchThread) -> bool:
	text = text.to_lower()
	var id := thread.id.to_lower()
	var color_name := thread.color_name.to_lower()
	return id.contains(text) or color_name.contains(text)

## Extend this lambda to customize thread button functionality.
## By default, prints the thread name.
func on_thread_button_clicked(button: ThreadButton):
	print("Thread Button pressed: %s" % button.thread.color_name)
