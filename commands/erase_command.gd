class_name EraseCommand
extends Command

var layer : XStitchDrawingLayer
var pixels_to_erase : Dictionary
var _previous_colors : Dictionary

func execute():
	for pixel in pixels_to_erase:
		_previous_colors[pixel] = layer.get_stitch_at(pixel)
		layer.erase_pixel(pixel)

func undo():
	for pixel in _previous_colors:
		if _previous_colors[pixel]:
			layer.draw_pixel(_previous_colors[pixel], pixel)
