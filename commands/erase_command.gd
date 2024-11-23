class_name EraseCommand
extends Command

var layer : XStitchDrawingLayer
var pixels_to_erase : Dictionary
var previous_colors : Dictionary

func execute():
	for pixel in pixels_to_erase:
		layer.erase_pixel(pixel)

func undo():
	for pixel in previous_colors:
		if previous_colors[pixel]:
			layer.draw_pixel(previous_colors[pixel], pixel)
