@icon("res://icons/thread_green.svg")
class_name LayerButtonContainer
extends Container

@export var layer_button : PackedScene

var _master_layers : Array[XStitchMasterLayer]:
	set = set_master_layers

var _buttons : Array[LayerButton]



#region Getters and Setters

## Set the collection of master layers.
func set_master_layers(value: Array[XStitchMasterLayer]) -> void:
	_master_layers = value
	_change_layers()

#endregion


#region Layer operations

func add_layer(layer: XStitchMasterLayer) -> void:
	_master_layers.append(layer)
	var btn = _create_layer_button(layer)
	_buttons.append(btn)


func remove_layer(layer: XStitchMasterLayer) -> void:
	_master_layers.erase(layer)
	for btn in _buttons:
		if btn.data == layer:
			btn.queue_free()


func _change_layers() -> void:
	# Delete all current
	for btn in _buttons:
		btn.queue_free()
	
	_buttons.clear()
	
	for layer in _master_layers:
		var btn = _create_layer_button(layer)
		_buttons.append(btn)

#endregion


func _create_layer_button(data: XStitchMasterLayer) -> LayerButton:
	var btn = layer_button.instantiate() as LayerButton
	add_child(btn)
	move_child(btn, 0)
	btn.data = data
	btn.pressed.connect(on_layer_button_clicked.bind(btn))
	btn.set_context_menu(%LayerContextMenu)
	btn.set_pressed_no_signal(data.is_active())
	return btn


func on_layer_button_clicked(button: LayerButton) -> void:
	print("Layer Button pressed: %s" % button.data.display_name)
