class_name BrushStrokeCommand
extends Command

## The layer to draw on.
var layer : XStitchDrawingLayer
## The tiles to draw.
var pixels_to_draw : Dictionary
var previous_colors : Dictionary
## The thread to draw with.
var thread : Skein

func execute():
	for pixel in pixels_to_draw:
		layer.draw_pixel(thread, pixel)

func undo():
	for pixel in previous_colors:
		if previous_colors[pixel]:
			layer.draw_pixel(previous_colors[pixel], pixel)
		else:
			layer.erase_pixel(pixel)
