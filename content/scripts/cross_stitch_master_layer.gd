class_name XStitchMasterLayer
extends Node2D

## Manages multiple [XStitchDrawingLayer]s. Handles calls from [XStitchCanvas].

## The [ThreadLayer] data associated with this master layer.
var data: ThreadLayer

func _ready() -> void:
	SignalBus.thread_layer_visibility_changed.connect(_show_hide_layer)
	SignalBus.thread_layer_changed.emit(_layer_changed)

func draw_stitch(thread: Skein, size: int, bounding_rect: Rect2i):
	# TODO: draw on layer based on tool, let layer handle drawing
	if !thread:
		return # TODO: notification? error?
	if size == 0:
		return # TODO: error? this shouldn't ever happen
	if !data.active:
		return
	if data.locked:
		SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		return # TODO: notification? UI thingy?
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.draw_stitch(thread, pos, bounding_rect, size)
	pass

func erase_stitch(size: int, bounding_rect: Rect2i):
	# TODO: erase on layer based on tool
	if !data.active: return
	if size == 0: return
	
	var pos = %FullStitchLayer.local_to_map(get_global_mouse_position())
	%FullStitchLayer.erase_stitch(pos, bounding_rect, size)
	pass

func _show_hide_layer(layer: ThreadLayer) -> void:
	if data != layer:
		return
	
	if data.visible:
		show()
	else:
		hide()

func _layer_changed(layer: ThreadLayer) -> void:
	if data != layer:
		return
	serialize()

func serialize():
	var _data : Dictionary = data.serialize()
	for child in get_children():
		_data.get_or_add(child.name, child.serialize())
	
	SignalBus.store_state.emit(_data, "layers.id:%s" % _data["id"])

func deserialize() -> void:
	pass
