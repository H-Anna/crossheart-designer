class_name BackStitchDrawingLayer
extends Node2D

# Skein to Array[BackStitch]
var _modulated_stitches_cache: Dictionary

func get_mouse_position():
	return get_global_mouse_position()

#func serialize() -> Array[Dictionary]:
	#var data: Array[Dictionary]
	#for thread in _modulated_stitches_cache:
		#var thread_coords_data: Dictionary
		#thread_coords_data.get_or_add("thread_id", thread.get_identifying_name())
		#var coordinates: Array[Dictionary]
		#for stitch in _modulated_stitches_cache[thread]:
			#var entry: Dictionary
			#entry.get_or_add("from", stitch.from_coordinate)
			#entry.get_or_add("to", stitch.to_coordinate)
			#coordinates.append(entry)
		#thread_coords_data.get_or_add("coordinates")
		#data.append(thread_coords_data)
	#return data
#
#func deserialize():
	#pass
