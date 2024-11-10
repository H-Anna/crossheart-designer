extends SpinBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.brush_size_changed.connect(update_value)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_value(size: int) -> void:
	set_value_no_signal(size)

func _on_value_changed(value: float) -> void:
	pass # Replace with function body.
