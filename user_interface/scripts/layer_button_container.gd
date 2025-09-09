@icon("res://icons/LayerButtonContainer.svg")
class_name LayerButtonContainer
extends Container

@export var layer_button : PackedScene

var thread_layers : Array[XStitchMasterLayer]:
	set(value):
		thread_layers = value
		_change_layers()

var _created_layer_buttons : Array[LayerButton]

func _ready() -> void:
	SignalBus.layer_added.connect(add_layer)
	SignalBus.layer_removed.connect(remove_layer)
	pass

func get_layer_count() -> int:
	return thread_layers.size()

func add_layer(layer: XStitchMasterLayer) -> void:
	thread_layers.append(layer)
	var btn = _create_layer_button(layer)
	_created_layer_buttons.append(btn)

func remove_layer(layer: XStitchMasterLayer) -> void:
	thread_layers.erase(layer)
	for btn in _created_layer_buttons:
		if btn.data == layer:
			btn.queue_free()

func _change_layers() -> void:
	# Delete all current
	for layer in _created_layer_buttons:
		layer.queue_free()
	
	_created_layer_buttons.clear()
	
	for layer in thread_layers:
		var btn = _create_layer_button(layer)
		_created_layer_buttons.append(btn)

func _create_layer_button(data: XStitchMasterLayer) -> LayerButton:
	var btn = layer_button.instantiate() as LayerButton
	add_child(btn)
	move_child(btn, 0)
	btn.data = data
	btn.pressed.connect(on_layer_button_clicked.bind(btn))
	btn.set_context_menu(%LayerContextMenu)
	btn.set_pressed_no_signal(data.is_active())
	return btn


func on_layer_button_clicked(button: LayerButton):
	print("Layer Button pressed: %s" % button.data.display_name)
