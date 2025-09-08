extends Node

var app: Node
var canvas: XStitchCanvas
var palette: Palette
var palette_controller: PaletteController

const MIN_BRUSH_SIZE := 1
const MAX_BRUSH_SIZE := 8
const BRUSH_CENTER_POINT: Dictionary = {
	1: Vector2i(0,0),
	2: Vector2i(1,1),
	3: Vector2i(1,1),
	4: Vector2i(1,1),
	5: Vector2i(2,2),
	6: Vector2i(3,3),
	7: Vector2i(3,3),
	8: Vector2i(3,3),
}

const DATA_PATH_DELIMITER = "."
const DATA_EQ_DELIMITER = ":"
