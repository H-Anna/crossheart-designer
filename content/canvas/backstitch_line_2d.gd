class_name BackstitchLine2D
extends Line2D

## A Line2D that represents a backstitch on the canvas.

## Enclosing rectangle to this line.
var enclosure : Rect2

## When entering the tree for the first time, cache the enclosure.
func _enter_tree() -> void:
	if !enclosure:
		enclosure = get_enclosure()

## Returns an enclosing rectangle to this line.
## Pass a float to [param grow] the rectangle on all sides.
func get_enclosure(grow: float = 0.0) -> Rect2:
	var min_x = minf(points[0].x, points[-1].x)
	var min_y = minf(points[0].y, points[-1].y)
	var max_x = maxf(points[0].x, points[-1].x)
	var max_y = maxf(points[0].y, points[-1].y)
	var width = max_x - min_x
	var height = max_y - min_y
	return Rect2(min_x, min_y, width, height).grow(grow)
