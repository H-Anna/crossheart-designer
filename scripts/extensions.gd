extends Node

func to_packedvector2array(input: Array) -> PackedVector2Array:
	var array : PackedVector2Array = []
	for elem in input:
		array.append(elem)
	return array

func get_neighbor_cells(source: TileMapLayer, coords: Vector2i) -> Array[Vector2i]:
	var cells : Array[Vector2i]
	cells.append(source.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_TOP_SIDE))
	cells.append(source.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_RIGHT_SIDE))
	cells.append(source.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE))
	cells.append(source.get_neighbor_cell(coords, TileSet.CELL_NEIGHBOR_LEFT_SIDE))
	return cells

func vector2i_is_within_rect2i(coords: Vector2i, rect: Rect2i) -> bool:
	return coords.x >= rect.position.x && coords.y >= rect.position.y && coords.x < rect.end.x && coords.y < rect.end.y

func higher_version(v1: String, v2: String):
	var vsep1 = v1.split(".")
	var vsep2 = v2.split(".")
	
	if vsep1.size() < vsep2.size():
		return v2
	elif vsep1.size() > vsep2.size():
		return v1
	else:
		for i in range(vsep1):
			var n1 = _get_version_number(vsep1[i], i)
			var n2 = _get_version_number(vsep2[i], i)
			if n1 < n2:
				return v2
			elif n1 > n2:
				return v1
	return v1

func get_major_version(v: String):
	return _get_version_number(v, 0)

func get_minor_version(v: String):
	return _get_version_number(v, 1)

func get_fix_version(v: String):
	return _get_version_number(v, 2)

func _get_version_number(v: String, i: int):
	var vsep = v.split(".")
	if i >= vsep.size():
		return -1
	return vsep[i].to_int()