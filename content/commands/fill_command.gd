class_name FillCommand
extends Command

## Command that fills an area on the canvas with the selected thread.

## The layer to draw on.
var layer : XStitchDrawingLayer
## Cells to fill.
var area: Array[Vector2i]
## Thread previously used on area.
var previous_thread: XStitchThread
## Thread to use on area.
var thread: XStitchThread

## Fills the area with the chosen thread.
func execute() -> void:
	for cell in area:
		layer.draw_cell(cell, thread)

## Restores the previous state of the area.
func undo() -> void:
	for cell in area:
		if previous_thread:
			layer.draw_cell(cell, previous_thread)
		else:
			layer.erase_cell(cell)
