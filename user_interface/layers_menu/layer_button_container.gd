@icon("res://icons/thread_green.svg")
class_name LayerButtonContainer
extends Container

## Container UI for [LayerButton]s. Manages its own buttons.

## The layer button scene.
@export var layer_button : PackedScene

## Array of [XStitchMasterLayer]s created in the canvas.
var _master_layers : Array[XStitchMasterLayer]:
	set = set_master_layers

## Array of [LayerButton]s that are children of this container.
var _buttons : Array[LayerButton]

# TODO: overhaul API

#region Getters and Setters

## Set the collection of master layers.
func set_master_layers(value: Array[XStitchMasterLayer]) -> void:
	_master_layers = value
	_change_layers()

#endregion


#region Layer operations

## Adds a layer to the array, and creates a button associated with the layer.
func add_layer(layer: XStitchMasterLayer) -> void:
	_master_layers.append(layer)
	var btn = _create_layer_button(layer)
	_buttons.append(btn)

## Removes a layer from the array, and deletes the button associated with this layer.
func remove_layer(layer: XStitchMasterLayer) -> void:
	_master_layers.erase(layer)
	for btn in _buttons:
		if btn.data == layer:
			btn.queue_free()
	_buttons.clear()

## Deletes all of its buttons and creates new ones.
func _change_layers() -> void:
	# Delete all current
	for btn in _buttons:
		btn.queue_free()
	
	_buttons.clear()
	
	for layer in _master_layers:
		var btn = _create_layer_button(layer)
		_buttons.append(btn)

#endregion

## Creates a [LayerButton] and adds it as a child.
## Adds the [param data] master layer to the button.[br]
## Returns the new layer button.
func _create_layer_button(data: XStitchMasterLayer) -> LayerButton:
	var btn = layer_button.instantiate() as LayerButton
	btn.data = data
	btn.set_context_menu(%LayerContextMenu)
	btn.set_pressed_no_signal(data.is_active())
	add_child(btn)
	move_child(btn, 0)
	return btn
