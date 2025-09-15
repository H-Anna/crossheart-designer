extends SpinBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_value = Globals.MIN_BRUSH_SIZE
	max_value = Globals.MAX_BRUSH_SIZE


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("increase-brush-size", false, true):
		value += 1
	
	if event.is_action_pressed("decrease-brush-size", false, true):
		value -= 1


func _on_value_changed(_value: float) -> void:
	SignalBus.brush_size_changed.emit(_value)
