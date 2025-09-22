extends ThreadButtonContainer

## A container for swapping threads using buttons.

## This indicates which thread button to hide, to avoid swapping a thread
## with the exact same thread.
var hidden_thread: XStitchThread:
	set = set_hidden_thread

## Connects to the signal emitted by [ThreadContextMenu],
## and displays all threads loaded in [ThreadsAtlas].
func _ready() -> void:
	SignalBus.thread_swap_in_progress.connect(set_hidden_thread)
	
	set_threads(ThreadsAtlas.get_all_threads())

## Sets the hidden thread. Hides/shows thread buttons.
func set_hidden_thread(value: XStitchThread) -> void:
	if hidden_thread != null:
		thread_button_dictionary[hidden_thread].show()
	
	hidden_thread = value
	thread_button_dictionary[hidden_thread].hide()
