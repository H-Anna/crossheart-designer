extends ContextMenu

const ADD_LAYER = 0
const RENAME = 1
const MOVE_UP = 2
const MOVE_DOWN = 3
const DELETE = 5

func _on_visibility_changed() -> void:
	var is_first = caller.get_index() == 0
	var is_last = caller.get_index() == %LayersContainer.get_child_count() - 1
	set_item_disabled(DELETE, is_first && is_last)
	set_item_disabled(MOVE_UP, is_first)
	set_item_disabled(MOVE_DOWN, is_last)


func _on_index_pressed(index: int) -> void:
	match index:
		ADD_LAYER:
			var cmd = AddLayerCommand.new()
			SignalBus.command_created.emit(cmd)
		RENAME:
			caller.rename_layer()
		MOVE_UP:
			var cmd = MoveLayerCommand.new()
			cmd.button = caller
			cmd.layer = caller.data
			cmd.move = 1
			SignalBus.command_created.emit(cmd)
		MOVE_DOWN:
			var cmd = MoveLayerCommand.new()
			cmd.button = caller
			cmd.layer = caller.data
			cmd.move = -1
			SignalBus.command_created.emit(cmd)
		DELETE:
			var cmd = RemoveLayerCommand.new()
			cmd.layer = caller.data
			SignalBus.command_created.emit(cmd)
		_:
			print_debug("Unhandled id: %s" % index)
