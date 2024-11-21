@icon("res://icons/LayerButtonContainer.svg")
class_name LayerButtonContainer
extends Container

@export var layer_button : PackedScene

var thread_layers : Array[ThreadLayer]:
	set(value):
		thread_layers = value
		_change_layers()

var _created_layers : Array[LayerButton]

func _ready() -> void:
	SignalBus.thread_layer_added.connect(add_layer)
	SignalBus.thread_layer_removed.connect(remove_layer)

func get_layer_count() -> int:
	return thread_layers.size()

func add_layer(layer: ThreadLayer) -> void:
	thread_layers.append(layer)
	var btn = _create_layer_button(layer)
	_created_layers.append(btn)
	#_change_layers()

func remove_layer(layer: ThreadLayer) -> void:
	thread_layers.erase(layer)
	for btn in _created_layers:
		if btn.data == layer:
			btn.queue_free()
	#_change_layers()

func _change_layers() -> void:
	# Delete all current
	for layer in _created_layers:
		layer.queue_free()
	
	_created_layers.clear()
	
	for layer in thread_layers:
		var btn = _create_layer_button(layer)
		_created_layers.append(btn)

func _create_layer_button(data: ThreadLayer) -> LayerButton:
	var btn = layer_button.instantiate() as LayerButton
	#_created_layers.append(btn)
	add_child(btn)
	btn.data = data
	btn.pressed.connect(on_layer_button_clicked.bind(btn))
	btn.set_context_menu(%LayerPopupMenu)
	btn.set_pressed_no_signal(data.active)
	return btn


func on_layer_button_clicked(button: LayerButton):
	print("Layer Button pressed: %s" % button.data.display_name)
