class_name ContextMenuButton
extends Button

## Activates and sets up a [ContextMenu]. This can help the
## context menu appear as if it was a RMB click menu, for example.

## The [ContextMenu] to activate.
var context_menu : ContextMenu

## Activates the context menu, if available,
## positions it at the mouse, and passes the parent Node
## as [member ContextMenu.caller].
func _on_pressed() -> void:
	if !context_menu:
		return
		
	context_menu.position = get_global_mouse_position()
	context_menu.caller = get_parent()
	context_menu.show()
