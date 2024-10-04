extends Window

@onready var container := $GridContainer

@export var palette : Palette
@export var skein_picker_ui : PackedScene

func _ready() -> void:
	SignalBus.skein_added_to_palette.connect(_on_skein_selected)
	_delete_elements()

func toggle_visibility() -> void:
	visible = !visible
	if visible:
		_load_elements(palette.colors)
	else:
		_delete_elements()

func _load_elements(except: Array):
	var skeins = SkeinsAtlas.skeins.values()
	if except == skeins:
		$Label.show()
	else:
		$Label.hide()
		for skein in skeins:
			if skein not in except:
				var ui = skein_picker_ui.instantiate()
				container.add_child(ui)
				ui.set_values(skein)

func _on_skein_selected(skein: Skein):
	toggle_visibility()

func _delete_elements():
	for child in container.get_children():
		child.queue_free()
