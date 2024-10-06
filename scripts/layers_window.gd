extends Window

@onready var canvas = $"../Canvas" #TODO: race condition
@onready var container = $VBoxContainer/ScrollContainer/LayersList
@onready var up_button = $VBoxContainer/HBoxContainer/UpButton
@onready var down_button = $VBoxContainer/HBoxContainer/DownButton
@export var layer_ui : PackedScene

var layers: Array[TileMapLayer]
var selected_element: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.layer_added.connect(_on_layers_changed)
	SignalBus.layer_removed.connect(_on_layers_changed)
	SignalBus.layer_ui_changed.connect(_on_layers_changed)
	_delete_elements()

func _exit_tree() -> void:
	SignalBus.layer_added.disconnect(_on_layers_changed)
	SignalBus.layer_removed.disconnect(_on_layers_changed)

func _on_layers_changed(_layer = null):
	layers = canvas.get_layers()
	layers.reverse()
	refresh()

func refresh():
	_delete_elements()
	_load_elements()
	_update_move_buttons()

func _load_elements():
	var single = layers.size() == 1
	var selected = false
	
	for layer in layers:
		var ui = layer_ui.instantiate()
		container.add_child(ui)
		ui.set_values(layer)
		ui.layer_renamed.connect(canvas.rename_layer as Callable)
		ui.layer_selected.connect(canvas.select_layer as Callable)
		ui.layer_selected.connect(_ui_layer_selected)
		ui.layer_visibility_toggled.connect(canvas.toggle_layer_visibility as Callable)
		if single:
			ui.x_button.disabled = true
		else:
			ui.layer_deleted.connect(canvas.delete_layer as Callable)
		
		if !selected && layer.active:
			ui.select()
			selected = true

func _delete_elements():
	for child in container.get_children():
		child.queue_free()

func _ui_layer_selected(layer: TileMapLayer):
	for child in container.get_children():
		if child.layer != layer:
			child.deselect()
		else:
			selected_element = child
	_update_move_buttons()

func _update_move_buttons():
	var idx = canvas.get_layer_index(canvas.selected_layer)
	up_button.disabled = layers.size() == 1 || idx == layers.size() - 1
	down_button.disabled = layers.size() == 1 || idx == 0

func _reorder_selected_element(delta: int):
	var idx = selected_element.get_index()
	container.move_child(selected_element, idx + delta)
	_update_move_buttons()
