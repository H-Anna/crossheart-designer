extends ContextMenu

const RENAME = 0
const DELETE = 1
const ADD_LAYER = 3

func _on_id_pressed(id: int) -> void:
	match id:
		RENAME:
			caller.rename_layer()
		DELETE:
			SignalBus.thread_layer_removed.emit(caller.data)
			pass
		ADD_LAYER:
			SignalBus.thread_layer_added.emit(ThreadLayer.new())
			pass
		_:
			print_debug("Unhandled id: %s" % id)


func _on_visibility_changed() -> void:
	set_item_disabled(DELETE, %LayersContainer.get_layer_count() == 1)
