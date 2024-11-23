extends Button

var context_menu : ContextMenu

func _on_pressed() -> void:
	if !context_menu:
		return
	#print("RMB pressed on node: %s" % get_path())
	context_menu.position = get_global_mouse_position()
	context_menu.caller = get_parent()
	context_menu.show()
