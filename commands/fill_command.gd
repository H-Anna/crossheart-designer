class_name FillCommand
extends Command

## The layer to draw on.
var layer : XStitchDrawingLayer
## Cells to fill.
var area: Array[Vector2i]
## Thread previously used on area.
var previous_thread: XStitchThread
## Thread to use on area.
var thread: XStitchThread

func execute():
	for cell in area:
		layer.draw_cell(cell, thread)

func undo():
	for cell in area:
		if previous_thread:
			layer.draw_cell(cell, previous_thread)
		else:
			layer.erase_cell(cell)
