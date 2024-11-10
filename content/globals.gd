extends Node

const MIN_BRUSH_SIZE := 1
const MAX_BRUSH_SIZE := 2
const BRUSH_SIZES: Dictionary = {
	1: [Vector2i(0,0)],
	2: [
		Vector2i(0,0),
		Vector2i(-1,0),
		Vector2i(0,-1),
		Vector2i(-1,-1),
		],
	3: [
		Vector2i(0,0),
		Vector2i(-1,0),
		Vector2i(0,-1),
		Vector2i(0,1),
		Vector2i(1,0),
		],
	4: [
		Vector2i(-1,-1),
		Vector2i(-1,0),
		Vector2i(-1,1),
		Vector2i(0,-1),
		Vector2i(0,0),
		Vector2i(0,1),
		Vector2i(1,-1),
		Vector2i(1,0),
		Vector2i(1,1),
		],
	
}
