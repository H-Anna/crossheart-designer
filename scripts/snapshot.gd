class_name Snapshot
extends Resource

## Stores the current state of the program.
## Contents can be saved to file or loaded.

var state : Dictionary

func dump_state():
	print(state)

#func store_data(data: Variant, path: String):
	#pass

func store_data(data: Variant, path: String):
	var path_elems = path.split(Globals.DATA_PATH_DELIMITER, false)
	var substate = state
	var get_element_index = func(input: String, _substate):
		var elem = input.split(Globals.DATA_EQ_DELIMITER)
		for i in range(_substate.size()):
			if _substate[i][elem[0]] == elem[1]:
				return i
		return -1
	
	# "content.canvas" -> state.content.canvas
	# "layers.id:zJF25gw" -> content.layers.[the element with the id]
	for i in range(path_elems.size()):
		var last = i == path_elems.size() - 1
		var keyed_element = path_elems[i].contains(Globals.DATA_EQ_DELIMITER)
		
		if !last:
			if keyed_element:
				var idx = get_element_index.call(path_elems[i], substate)
				if idx == -1:
					var d = {}
					substate.append({})
					substate = substate.back()
				else:
					substate = substate[idx]
			else:
				substate = substate.get_or_add(path_elems[i], {})
		else:
			if keyed_element:
				var idx = get_element_index.call(path_elems[i], substate)
				if idx == -1:
					substate.append(data)
				else:
					substate[idx] = data
			else:
				substate[path_elems[i]] = data
	
	print(state)

func store_palette(palette: Palette):
	state["palette"] = palette.serialize()

func store_canvas(canvas: Canvas):
	state["canvas"] = canvas.serialize()

func store_layer(layer: TileMapLayer):
	var layer_data = layer.serialize()
	var layers_array = state.get_or_add("layers", [])
	if layers_array.is_empty():
		layers_array.append(layer_data)
		return
	
	## TODO: does this work??
	var filter = layers_array.filter(func(x): return layer.name == x["name"])
	if filter.is_empty():
		layers_array.append(layer_data)
	else:
		var old_data = filter.front()
		var idx = layers_array.find(old_data)
		layers_array[idx] = layer_data

func drop_layer(layer: TileMapLayer):
	var stored = state["layers"].filter(func(x): return layer.name == x["name"]).front()
	state["layers"].erase(stored)
	state["canvas"]["layers"].erase(layer.name)

## Creates a deep copy of this snapshot.
## The duplicate() function can't be used on nested Dictionaries,
## so they must be deep copied recursively.
func deep_copy() -> Snapshot:
	var copy = self.duplicate(true)
	copy.state = _deep_copy_subresource(state)
	return copy

## Making up for the shortcomings of duplicate() using this godforsaken method
func _deep_copy_subresource(subresource):
	var copy
	var indices
	match typeof(subresource):
		TYPE_DICTIONARY:
			indices = subresource.keys()
			copy = {}
		TYPE_ARRAY:
			indices = range(subresource.size())
			copy = []
			copy.resize(subresource.size())
		_:
			copy = subresource
			return copy
	
	for index in indices:
		copy[index] = _deep_copy_subresource(subresource[index])
	return copy
