extends SpinBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	min_value = Globals.MIN_BRUSH_SIZE
	max_value = Globals.MAX_BRUSH_SIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("increase-brush-size", true):
		set_value_no_signal(mini(value + 1, max_value))
		SignalBus.brush_size_changed.emit(value)
	
	if Input.is_action_just_pressed("decrease-brush-size", true):
		set_value_no_signal(maxi(value - 1, min_value))
		SignalBus.brush_size_changed.emit(value)

func update_value(size: int) -> void:
	set_value_no_signal(size)

func _on_value_changed(value: float) -> void:
	SignalBus.brush_size_changed.emit(value)
