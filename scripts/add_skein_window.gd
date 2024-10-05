extends Window

@onready var container := $GridContainer

@export_file("*.gd") var script_path : String
@export var palette : Palette
@export var skein_picker_ui : PackedScene

func _ready() -> void:
	_delete_elements()

func toggle_visibility() -> void:
	visible = !visible

func _load_elements(except: Array):
	var skeins = SkeinsAtlas.skeins.values()
	if except == skeins:
		$Label.show()
	else:
		$Label.hide()
		var script = load(script_path)
		for skein in skeins:
			if skein not in except:
				var ui = skein_picker_ui.instantiate()
				ui.set_script(script)
				container.add_child(ui)
				ui.set_values(skein)
				ui.skein_selected.connect(_on_skein_selected)

func _on_skein_selected(skein: Skein):
	SignalBus.skein_added_to_palette.emit(skein)
	hide()

func _delete_elements():
	for child in container.get_children():
		child.queue_free()

func _on_visibility_changed() -> void:
	if visible:
		_load_elements(palette.colors)
	else:
		_delete_elements()
