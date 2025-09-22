class_name LayerButton
extends Button
## A UI button used to control an [XStitchMasterLayer].

## Icon that appears on the Visibility button
## when the layer is visible.
@export var show_icon : CompressedTexture2D

## Icon that appears on the Visibility button
## when the layer is hidden.
@export var hide_icon : CompressedTexture2D

## Icon that appears on the Lock button
## when the layer is locked.
@export var locked_icon : CompressedTexture2D

## Icon that appears on the Lock button
## when the layer is unlocked.
@export var unlocked_icon : CompressedTexture2D

## The [XStitchMasterLayer] controlled by this button.
var data : XStitchMasterLayer:
	set = set_data


#region Getters and Setters

## Sets the [ContextMenu] for this button.
func set_context_menu(context_menu: Node) -> void:
	$RMB.context_menu = context_menu

## Sets the [XStitchMasterLayer] for this button.
## The button will then manage the underlying layer.
## Updates the button UI to reflect the current state of the layer.
func set_data(value: XStitchMasterLayer) -> void:
	data = value
	text = data.display_name
	update_visibility_button()
	update_lock_button()
	update_display_name()

#endregion

#region Button operations

## Emits a signal to select this button's [XStitchMasterLayer].
func _on_pressed() -> void:
	SignalBus.layer_selected.emit(data)


## Initiates the layer renaming process.
## Shows a [LineEdit] field and gives focus to it.
func rename_layer() -> void:
	%NameField.text = text
	text = ""
	%NameField.show()
	%NameField.grab_focus()
	%NameField.select_all()


## Hides the [LineEdit] name field when it loses focus.
func _on_name_field_focus_exited() -> void:
	text = data.display_name
	%NameField.hide()


## Changes the icon on the button when the layer becomes visible or hidden.
func update_visibility_button() -> void:
	if data.visible:
		%VisibilityButton.icon = show_icon
	else:
		%VisibilityButton.icon = hide_icon


## Changes the icon on the button when the layer is locked or unlocked.
func update_lock_button() -> void:
	if data.locked:
		%LockButton.icon = locked_icon
	else:
		%LockButton.icon = unlocked_icon


## Updates the button text when the layer is renamed.
func update_display_name() -> void:
	text = data.display_name

#endregion

#region Layer operations

## Creates a command that changes the locked state of the layer.
func _on_lock_button_pressed() -> void:
	var cmd = ToggleLayerLockedCommand.new()
	cmd.layer = data
	cmd.button = self
	SignalBus.command_created.emit(cmd)


## Creates a command that changes the name of the layer.
func _on_name_field_text_submitted(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if !new_text.is_empty():
		var cmd = RenameLayerCommand.new()
		cmd.layer = data
		cmd.button = self
		cmd.new_name = new_text
		SignalBus.command_created.emit(cmd)
	%NameField.hide()


## Creates a command that changes the visibility of the layer.
func _on_visibility_button_pressed() -> void:
	var cmd = ToggleLayerVisibleCommand.new()
	cmd.layer = data
	cmd.button = self
	SignalBus.command_created.emit(cmd)

#endregion
