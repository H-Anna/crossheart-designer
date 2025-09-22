extends ThreadButtonContainer

## A container for adding threads using buttons.

## Displays all threads loaded in [ThreadsAtlas].
func _ready() -> void:
	set_threads(ThreadsAtlas.get_all_threads())
