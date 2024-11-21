class_name LayerButton
extends Button

@export var show_icon : CompressedTexture2D
@export var hide_icon : CompressedTexture2D
@export var locked_icon : CompressedTexture2D
@export var unlocked_icon : CompressedTexture2D

var data : ThreadLayer:
	set(value):
		data = value
		_update_ui()

#func _ready() -> void:
	#SignalBus.thread_layer_removed.connect(queue_free.unbind(1))

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
	_update_visibility_button()
	_update_lock_button()

func _on_name_field_text_submitted(new_text: String) -> void:
	new_text = new_text.strip_edges()
	if !new_text.is_empty():
		data.display_name = new_text
	text = data.display_name
	%NameField.hide()

func _on_name_field_focus_exited() -> void:
	text = data.display_name
	%NameField.hide()

func _on_visibility_button_pressed() -> void:
	data.visible = !data.visible
	_update_visibility_button()
	SignalBus.thread_layer_visibility_changed.emit(data)

func _update_visibility_button():
	if data.visible:
		%VisibilityButton.icon = show_icon
	else:
		%VisibilityButton.icon = hide_icon

func _on_lock_button_pressed() -> void:
	data.locked = !data.locked
	_update_lock_button()
	SignalBus.thread_layer_lock_changed.emit(data)
	SignalBus.thread_layer_changed.emit(data)

func _update_lock_button():
	if data.locked:
		%LockButton.icon = locked_icon
	else:
		%LockButton.icon = unlocked_icon

func _on_pressed() -> void:
	data.active = true
	SignalBus.thread_layer_selected.emit(data)
