class_name AddBackstitchCommand
extends Command

## Command that adds a backstitch to the given layer.

## The layer to draw on.
var layer : BackStitchDrawingLayer

## The thread to draw with.
var thread : XStitchThread

## The points of the Line2D.
var points : Array[Vector2]

## The resulting line.
var line : Line2D

## Whether the command has already had a preview.
## Prevents executing on initial creation, as this is handled by separate logic.
var preview : bool #= true

## Adds the backstitch.
func execute() -> void:
	if preview:
		preview = false
		return
	
	if !line:
		line = layer.draw_stitch(thread, points)
	else:
		layer.add_child(line)

## Deletes the backstitch added previously.
func undo() -> void:
	layer.remove_child(line)

## Prints a string associated with this command.
## Can be used to push debug messages.
func get_string() -> String:
	return "Override this method!"
