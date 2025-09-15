class_name EraseCommand
extends Command

var layer : XStitchDrawingLayer
var cells_to_erase : Dictionary
var previous_stitches : Dictionary

## The brush size.
var brush_size: int

## Whether the command has already had a preview.
## Prevents executing on initial creation, as this is
## handled by separate logic.
var preview : bool = true

func execute():
	if preview:
		preview = false
		return
	
	for cell in cells_to_erase:
		layer.erase_cell(cell)

func undo():
	for cell in previous_stitches:
		if previous_stitches[cell]:
			layer.draw_cell(cell, previous_stitches[cell])
