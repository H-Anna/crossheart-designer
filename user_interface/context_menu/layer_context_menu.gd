class_name LayerContextMenu
extends ContextMenu
## Context menu for [LayerButton]s 
## and corresponding [XStitchMasterLayer]s.

## "Add layer" menu option.
## Selecting this adds a new layer at the top.[br]
const ADD_LAYER = 0

## "Rename layer" menu option.
## Allows the user to rename the layer.[br]
const RENAME = 1

## "Move up" menu option.
## Allows the user to move the layer toward the top.[br]
const MOVE_UP = 2

## "Move down" menu option.
## Allows the user to move the layer toward the bottom.[br]
const MOVE_DOWN = 3

## "Delete" menu option.
## Allows the user to delete the layer.[br]
const DELETE = 5

## Called when the context menu shows or hides.
## Enables or disables certain menu options based on
## the caller.
func _on_visibility_changed() -> void:
	var layer_count = %Canvas.get_layer_count()
	var is_first = caller.get_index() == 0
	var is_last = caller.get_index() == layer_count - 1
	set_item_disabled(DELETE, is_first && is_last)
	set_item_disabled(MOVE_UP, is_first)
	set_item_disabled(MOVE_DOWN, is_last)

## Called when one of the options is selected.
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
