class_name XStitchMasterLayer
extends Node2D

## Manages multiple [XStitchDrawingLayer]s. Handles calls from [XStitchCanvas].

## The [ThreadLayer] data associated with this master layer.
@onready var id : String = Extensions.generate_unique_string(Extensions.layer_name_length)
var display_name : String = "New Layer"
var locked : bool = false

func _ready() -> void:
	#SignalBus.thread_layer_visibility_changed.connect(_show_hide_layer)
	#SignalBus.thread_layer_changed.emit(_layer_changed)
	pass

func is_active():
	return Globals.canvas.active_layer == self

func get_current_cell():
	return get_active_sublayer().get_mouse_position()

func get_active_sublayer() -> XStitchDrawingLayer:
	return %FullStitchLayer #TODO: return based on active tool

func draw_stitch(thread: Skein, size: int, bounding_rect: Rect2i):
	# TODO: draw on layer based on tool, let layer handle drawing
	if !thread:
		return # TODO: notification? error?
	if size == 0:
		return # TODO: error? this shouldn't ever happen
	if !is_active():
		return
	#if locked:
		#SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		#return # TODO: notification? UI thingy?
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.draw_stitch(thread, pos, bounding_rect, size)
	pass

func erase_stitch(size: int, bounding_rect: Rect2i):
	# TODO: erase on layer based on tool
	if !is_active(): return
	if size == 0: return
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.erase_stitch(pos, bounding_rect, size)
	pass

#func _show_hide_layer(layer: ThreadLayer) -> void:
	#if visible:
		#show()
	#else:
		#hide()

func _layer_changed(layer: ThreadLayer) -> void:
	#if data != layer:
		#return
	serialize()

func serialize():
	var data: Dictionary
	data.get_or_add("id", id)
	data.get_or_add("display_name", display_name)
	data.get_or_add("visible", visible)
	data.get_or_add("locked", locked)
	data.get_or_add("active", is_active())
	for child in get_children():
		data.get_or_add(child.name, child.serialize())
	
	SignalBus.store_state.emit(data, "layers.id:%s" % id)

func deserialize() -> void:
	pass
