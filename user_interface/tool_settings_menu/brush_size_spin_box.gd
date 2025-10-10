class_name BrushSizeSpinBox
extends SpinBox
## A spin box UI element that determines brush size.

## Called when the node enters the scene tree for the first time.[br]
## Sets the minimum and maximum values for the spin box.
func _ready() -> void:
	min_value = Globals.MIN_BRUSH_SIZE
	max_value = Globals.MAX_BRUSH_SIZE

## Called when unhandled input is detected (eg. key press).
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("increase-brush-size", false, true):
		value += step
	
	if event.is_action_pressed("decrease-brush-size", false, true):
		value -= step

## Called when the value has been changed.
func _on_value_changed(_value: float) -> void:
	SignalBus.brush_size_changed.emit(_value)
