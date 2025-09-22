class_name BrushStrokeCommand
extends Command

## A command that describes a brush stroke.

## The layer to draw on.
var layer : XStitchDrawingLayer

## The cells to draw.
var cells_to_draw : Dictionary
var previous_stitches : Dictionary

## The thread to draw with.
var thread : XStitchThread

## The brush size.
var brush_size: int

## Whether the command has already had a preview.
## Prevents executing on initial creation, as this is handled by separate logic.
var preview : bool = true

## Executes the brush stroke.
func execute() -> void:
	if preview:
		preview = false
		return
	
	for cell in cells_to_draw:
		layer.draw_cell(cell, thread)

## Deletes the brush stroke.
func undo() -> void:
	for cell in previous_stitches:
		if previous_stitches[cell]:
			layer.draw_cell(cell, thread)
		else:
			layer.erase_cell(cell)
