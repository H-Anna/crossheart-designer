class_name BrushStrokeCommand
extends Command

## The layer to draw on.
var layer : XStitchDrawingLayer
## The tiles to draw.
var pixels_to_draw : Dictionary
var _previous_colors : Dictionary
## The thread to draw with.
var thread : Skein

func execute():
	for pixel in pixels_to_draw:
		_previous_colors[pixel] = layer.get_stitch_at(pixel)
		layer.draw_pixel(thread, pixel)

func undo():
	for pixel in _previous_colors:
		if _previous_colors[pixel]:
			layer.draw_pixel(_previous_colors[pixel], pixel)
		else:
			layer.erase_cell(pixel)
