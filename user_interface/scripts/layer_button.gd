class_name LayerButton
extends Button

@export var show_icon : CompressedTexture2D
@export var hide_icon : CompressedTexture2D
@export var locked_icon : CompressedTexture2D
@export var unlocked_icon : CompressedTexture2D

var data : XStitchMasterLayer:
	set(value):
		data = value
		_update_ui()

func _ready() -> void:
	pass

func set_context_menu(context_menu: Node) -> void:
	find_child("RMB").context_menu = context_menu

func rename_layer() -> void:
	%NameField.text = text
	text = ""
	%NameField.show()
	%NameField.grab_focus()
	%NameField.select_all()

func _update_ui():
	text = data.display_name
	update_visibility_button()
	update_lock_button()
	update_display_name()

func _on_name_field_text_submitted(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if !new_text.is_empty():
		var cmd = RenameLayerCommand.new()
		cmd.layer = data
		cmd.button = self
		cmd.new_name = new_text
		SignalBus.command_created.emit(cmd)
		
	%NameField.hide()

func _on_name_field_focus_exited() -> void:
	text = data.display_name
	%NameField.hide()

func _on_visibility_button_pressed() -> void:
	var cmd = ToggleLayerVisibleCommand.new()
	cmd.layer = data
	cmd.button = self
	SignalBus.command_created.emit(cmd)

func update_visibility_button():
	if data.visible:
		%VisibilityButton.icon = show_icon
	else:
		%VisibilityButton.icon = hide_icon

func _on_lock_button_pressed() -> void:
	var cmd = ToggleLayerLockedCommand.new()
	cmd.layer = data
	cmd.button = self
	SignalBus.command_created.emit(cmd)

func update_lock_button():
	if data.locked:
		%LockButton.icon = locked_icon
	else:
		%LockButton.icon = unlocked_icon

func update_display_name():
	text = data.display_name

func _on_pressed() -> void:
	data.active = true
	SignalBus.thread_layer_selected.emit(data)
