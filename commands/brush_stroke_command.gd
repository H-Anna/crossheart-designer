class_name BrushStrokeCommand
extends Command

## The layer to draw on.
var layer : XStitchDrawingLayer
## The cells to draw.
var cells_to_draw : Dictionary
var previous_stitches : Dictionary
## The thread to draw with.
var thread : XStitchThread
var preview : bool = true

func execute():
	if preview:
		preview = false
		return
	
	for cell in cells_to_draw:
		layer.draw_cell(cell, thread)

func undo():
	for cell in previous_stitches:
		if previous_stitches[cell]:
			layer.draw_cell(previous_stitches[cell], thread)
		else:
			layer.erase_cell(cell)
