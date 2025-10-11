class_name EraseBackstitchCommand
extends Command

## Command that erases one or more backstitches.

## The layer to erase from.
var layer : BackStitchDrawingLayer

## The [Line2D] stitches to erase.
var lines : Array[Line2D]

## Whether the command has already had a preview.
## Prevents executing on initial creation, as this is handled by separate logic.
var preview : bool

## Used to perform a series of operations associated with the command.
func execute() -> void:
	if preview:
		preview = false
		return
	
	for line in lines:
		layer.remove_child(line)

## Initiates operations that aim to do the "opposite" of [method execute].
func undo() -> void:
	for line in lines:
		layer.add_child(line)

## Returns [code]true[/code] if the number of [member lines] is greater than zero.
func is_valid() -> bool:
	return lines.size() > 0
