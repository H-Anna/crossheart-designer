@icon("res://icons/LayerButtonContainer.svg")
class_name LayerButtonContainer
extends Container

@export var layer_button : PackedScene

var thread_layers : Array[ThreadLayer]:
	set(value):
		thread_layers = value
		_change_layers()

var _created_layers : Array[Node]

func get_layer_count() -> int:
	return thread_layers.size()

#func _ready() -> void:
	#if thread_layers.is_empty():
		#thread_layers.append(ThreadLayer.new())
		#_change_layers()

func add_layer(layer: ThreadLayer = ThreadLayer.new()) -> void:
	thread_layers.append(layer)
	_change_layers()

func _change_layers() -> void:
	# Delete all current
	for layer in _created_layers:
		layer.queue_free()
	
	_created_layers.clear()
	
	for l in thread_layers:
		var btn = layer_button.instantiate() as LayerButton
		_created_layers.append(btn)
		add_child(btn)
		btn.data = l
		btn.pressed.connect(on_layer_button_clicked.bind(btn))
		btn.set_context_menu(%LayerPopupMenu)

func on_layer_button_clicked(button: LayerButton):
	print("Layer Button pressed: %s" % button.data.display_name)
