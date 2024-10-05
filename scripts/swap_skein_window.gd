extends Window

@onready var container := $GridContainer

@export_file("*.gd") var script_path : String
@export var palette : Palette
@export var skein_picker_ui : PackedScene

var skein_to_swap : Skein
var swap_callable : Callable

func _ready() -> void:
	_delete_elements()

func set_skein_to_swap(skein: Skein):
	skein_to_swap = skein
	if visible:
		_delete_elements()
		_load_elements(skein)

func toggle_visibility() -> void:
	visible = !visible

func _load_elements(except: Skein):
	var skeins = SkeinsAtlas.skeins.values()
	skeins.erase(except)
	var script = load(script_path)
	for skein in skeins:
		var ui = skein_picker_ui.instantiate()
		ui.set_script(script)
		container.add_child(ui)
		ui.set_values(skein)
		ui.skein_selected.connect(_on_skein_selected)

func _delete_elements():
	for child in container.get_children():
		child.queue_free()

func _on_skein_selected(new_skein: Skein):
	swap_callable.call(skein_to_swap, new_skein)
	hide()

func _on_visibility_changed() -> void:
	if visible:
		_load_elements(skein_to_swap)
	else:
		_delete_elements()
