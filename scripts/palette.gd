class_name Palette
extends Node

@export var colors : Array[Skein]

func _ready() -> void:
	SignalBus.skein_added_to_palette.connect(add_skein)
	SignalBus.skein_removed_from_palette.connect(remove_skein)
	SignalBus.current_snapshot_changed.connect(deserialize)

func clear():
	colors.clear()
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func serialize() -> Array:
	var arr : Array[Dictionary]
	for skein in colors:
		var elem : Dictionary
		elem.get_or_add("brand", skein.brand)
		elem.get_or_add("id", skein.id)
		elem.get_or_add("global_id", skein.get_identifying_name())
		elem.get_or_add("color_name", skein.color_name)
		elem.get_or_add("color_hex", skein.color.to_html(false))
		arr.append(elem)
	return arr

func deserialize(snapshot: Snapshot):
	colors.clear()
	var data = snapshot.state["palette"] as Array
	for dict in data:
		colors.append(SkeinsAtlas.get_skein_by_global_id(dict["global_id"]))
	SignalBus.palette_ui_changed.emit(self)

func add_skein(skein: Skein):
	colors.append(skein)
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)

func remove_skein(skein: Skein):
	colors.erase(skein)
	SignalBus.palette_changed.emit(self)
	SignalBus.palette_ui_changed.emit(self)
