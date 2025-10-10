class_name CommandManager
extends Node

## An undo-redo interface for [Command]s. Does NOT use [UndoRedo].

## Array of commands in the order of execution.
var command_history : Array[Command]

## The index of the command that has been just performed. Keeps track of the
## user's place in the history.
var current_command_idx : int = -1

## Sets up signal connection that lets commands be created anywhere in code.
func _ready() -> void:
	SignalBus.command_created.connect(execute_command)

## Listens for [kbd]ui_undo[/kbd] and [kbd]ui_redo[/kbd] input events.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_undo", true):
		undo()
	if event.is_action_pressed("ui_redo", true):
		redo()

## Executes the incoming command and saves it to the command history.
func execute_command(cmd: Command) -> void:
	if !cmd.is_valid():
		return
	
	if current_command_idx < command_history.size() - 1:
		command_history.resize(current_command_idx + 1)
	cmd.execute()
	command_history.push_back(cmd)
	current_command_idx += 1

## Undoes the last command. Prints message if no commands are available for undo.
func undo() -> void:
	if current_command_idx >= 0:
		command_history[current_command_idx].undo();
		current_command_idx -= 1
	else:
		print("Nothing to undo.")

## Redoes the last undone command. Prints message if no commands are available for redo.
func redo() -> void:
	if current_command_idx < command_history.size() - 1:
		current_command_idx += 1
		command_history[current_command_idx].execute();
	else:
		print("Nothing to redo.")

## Clears the command history.
func clear_history() -> void:
	command_history.clear()
	current_command_idx = -1
