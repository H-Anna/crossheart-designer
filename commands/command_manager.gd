class_name CommandManager
extends Node

var command_history : Array[Command]
var current_command_idx : int = -1

func _ready() -> void:
	SignalBus.command_created.connect(execute_command)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_undo", true):
		undo()
	elif Input.is_action_just_pressed("ui_redo", true):
		redo()

## Executes the incoming command and saves it to the command history.
func execute_command(cmd: Command):
	if current_command_idx < command_history.size() - 1:
		command_history.resize(current_command_idx + 1)
	cmd.execute()
	command_history.push_back(cmd)
	current_command_idx += 1

## Undoes the last command.
func undo():
	if current_command_idx >= 0:
		command_history[current_command_idx].undo();
		current_command_idx -= 1
	else:
		print("Nothing to undo.")

## Redoes the last undone command.
func redo():
	if current_command_idx < command_history.size() - 1:
		current_command_idx += 1
		command_history[current_command_idx].execute();
	else:
		print("Nothing to redo.")

func clear_history():
	command_history.clear()
	current_command_idx = -1
