class_name XStitchMasterLayer
extends Node2D

## Manages multiple [XStitchDrawingLayer]s. Handles calls from [XStitchCanvas].

## The [ThreadLayer] data associated with this master layer.
@onready var id : String = Extensions.generate_unique_string(Extensions.layer_name_length):
	set(value):
		id = value
		name = value

@onready var layers : Dictionary = {
	"FULL" : %FullStitchLayer,
	#"SMALL" : %SmallStitchLayer,
	#"KNOT" : %KnotLayer,
	#"BACK" : %BackStitchLayer
}

## The name of the layer displayed to the user.
var display_name : String = "New Layer"

## The locked state of the layer.
## Locking or hiding a layer prevents drawing.
var locked : bool = false

func _ready() -> void:
	name = id
	pass

func is_active():
	return Globals.canvas.active_layer == self

func get_current_cell():
	return get_active_sublayer().get_mouse_position()

func get_active_sublayer() -> XStitchDrawingLayer:
	return %FullStitchLayer #TODO: return based on active tool

func add_stitches(thread: XStitchThread, context: Dictionary):
	for key in layers:
		layers[key].add_stitches(thread, context[key])

func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for key in layers:
		context[key] = layers[key]._erase_cells_with_thread(thread)
	return context

func draw_stitch(thread: XStitchThread, size: int, bounding_rect: Rect2i):
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

func serialize():
	var data = {}
	data.get_or_add("id", id)
	data.get_or_add("display_name", display_name)
	data.get_or_add("visible", visible)
	data.get_or_add("locked", locked)
	data.get_or_add("active", is_active())
	for child in get_children():
		data.get_or_add(child.name, child.serialize())
	return data

func deserialize(data: Dictionary) -> void:
	id = data.get("id", "ERR")
	name = id
	display_name = data.get("display_name")
	visible = data.get("visible", true)
	locked = data.get("locked", false)
	var _active = data.get("active", false)
	if _active:
		Globals.canvas.select_layer(self)
	for child in get_children():
		child.deserialize(data.get(child.name))
