extends SubViewportContainer

func _on_mouse_entered() -> void:
	SignalBus.canvas_focus_changed.emit(true)

func _on_mouse_exited() -> void:
	SignalBus.canvas_focus_changed.emit(false)
