class_name EraseCommand
extends Command

## A command that describes an erase stroke.

## The layer to erase from.
var layer : XStitchDrawingLayer

## The vector positions to erase.
var cells_to_erase : Dictionary

## The thread colors at the cells this command erases.
## Used to restore state before erasing.
var previous_stitches : Dictionary

## The brush size.
var brush_size: int

## Whether the command has already had a preview.
## Prevents executing on initial creation, as this is
## handled by separate logic.
var preview : bool = true

## Commits an erase stroke.
func execute() -> void:
	if preview:
		preview = false
		return
	
	for cell in cells_to_erase:
		layer.erase_cell(cell)

## Undoes the erase stroke, restoring previous cell data.
func undo() -> void:
	for cell in previous_stitches:
		if previous_stitches[cell]:
			layer.draw_cell(cell, previous_stitches[cell])

## This command is only valid if anything has been erased.
func is_valid() -> bool:
	for cell in cells_to_erase:
		if previous_stitches[cell]:
			return true
	return false
