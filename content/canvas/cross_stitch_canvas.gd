class_name XStitchCanvas
extends Node2D

## Manages a number of [XStitchMasterLayer]s.

## Layer scene to instantiate.
@export var layer_scene : PackedScene

## The UI element that contains LayerButtons.
@export var ui_layer_button_container : LayerButtonContainer

## Whether the canvas has GUI input focus.
var focused := false

## The size and position of the canvas.
## Used to restrict drawing within the canvas.
var bounding_rect : Rect2i

## The layer currently being drawn on.
var active_layer : XStitchMasterLayer

## The current brush size.
var brush_size := 1

## The stored command.
var _cmd : Command

## Stores itself in [Globals] and connects signals.
func _ready() -> void:
	Globals.canvas = self
	
	SignalBus.canvas_focus_changed.connect(_focus_changed)
	SignalBus.brush_size_changed.connect(func(size): brush_size = size)
	
	SignalBus.layer_selected.connect(select_layer)
	%XStitchToolController.tool_selected.connect(update_tool)
	
	# TODO: ability for custom size or resize canvas
	bounding_rect = $BackgroundLayer.get_used_rect()
	$GridElements.tilemap_rect = bounding_rect
	$GridElements.queue_redraw()
	
	add_layer()

#region Input Handling

## Handles MKB input for the canvas, based on the current tool.
func _unhandled_input(event: InputEvent) -> void:
	if !accepts_input():
		return
	
	var tool = %XStitchToolController.get_current_tool()
	match tool.method:
		XStitchTool.Method.DRAW_ERASE:
			if event is InputEventMouseMotion:
				active_layer.update_command()
			handle_draw_input(event)
			handle_erase_input(event)
			
		XStitchTool.Method.COLOR_PICK:
			handle_color_pick_input(event)
			
		XStitchTool.Method.FILL:
			handle_fill_input(event)
		_:
			pass
	pass

## Handles brush stroke input.
func handle_draw_input(event: InputEvent) -> void:
	## Starting brush stroke
	if event.is_action_pressed("draw"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			active_layer.create_brush_stroke_command(get_current_thread(), brush_size)
			active_layer.update_command()
	
	## Ending brush stroke
	if event.is_action_released("draw"):
		active_layer.finalize_command()

## Handles erase stroke input.
func handle_erase_input(event: InputEvent) -> void:
	if event.is_action_pressed("erase"):
		if active_layer.locked:
			SignalBus.toast_notification.emit("Layer locked! Unlock to draw on it.")
		else:
			active_layer.create_erase_command(brush_size)
			active_layer.update_command()
	
	if event.is_action_released("erase"):
		active_layer.finalize_command()

## Handles input for the color pick tool.
func handle_color_pick_input(event: InputEvent) -> void:
	if event.is_action_pressed("draw"):
		var thread = get_top_layer().pick_thread()
		if thread != null:
			%PaletteController.pick_thread(thread)
			%XStitchToolController.select_tool(XStitchTool.Method.DRAW_ERASE)

## Handles input for the fill tool.
func handle_fill_input(event: InputEvent) -> void:
	if event.is_action_pressed("draw"):
		active_layer.create_fill_command(get_current_thread())
		pass

## Returns true or false depending on if the canvas accepts input.
## The canvas only accepts input if it receives mouse focus and if a thread
## has been selected in the palette.
func accepts_input() -> bool:
	return focused && get_current_thread()

## Updates the cursor layer based on the selected tool.
func update_tool(tool: XStitchTool) -> void:
	$CursorLayer.visible = tool.enable_cursor_layer

#endregion

## Handles mouse input focus change.
func _focus_changed(_focused: bool) -> void:
	focused = _focused
	#$CursorLayer.visible = focused
	
	if !focused && _cmd:
		active_layer.finalize_command()

#region Layer Management

## Adds a layer to the canvas.
func add_layer(layer: XStitchMasterLayer = null) -> XStitchMasterLayer:
	if !layer:
		layer = layer_scene.instantiate() as XStitchMasterLayer
		layer.bounding_rect = bounding_rect
	$LayersContainer.add_child(layer)
	
	if !active_layer:
		select_layer(layer)
		
	ui_layer_button_container.add_layer(layer)
	return layer

## Selects a layer. Selected layer becomes active and handles user input.
func select_layer(layer: XStitchMasterLayer) -> void:
	active_layer = layer

## Removes a layer.
func remove_layer(layer: XStitchMasterLayer) -> void:
	if layer.is_active():
		var idx = layer.get_index()
		var next_layer = $LayersContainer.get_child((idx + 1) % get_layer_count())
		select_layer(next_layer)
	
	$LayersContainer.remove_child(layer)
	ui_layer_button_container.remove_layer(layer)

## Returns the layer that is in front.
func get_top_layer() -> XStitchMasterLayer:
	return $LayersContainer.get_child(-1)

#endregion

## Returns the current thread used by the [PaletteController].
func get_current_thread() -> XStitchThread:
	return Globals.palette_controller.get_selected_thread()

#region Commands actions
## Adds stitches with [param thread] to multiple layers, described by
## [param context].
func add_stitches(thread: XStitchThread, context: Dictionary) -> void:
	for master_layer in $LayersContainer.get_children():
		master_layer.add_stitches(thread, context[master_layer.name])
	pass

## Removes stitches done with [param thread].
## Returns a multi-level dictionary that describes which cells had
## stitches with this thread on which layers.
func remove_stitches(thread: XStitchThread) -> Dictionary:
	var context: Dictionary
	for master_layer in $LayersContainer.get_children():
		context[master_layer.name] = master_layer.remove_stitches(thread)
	return context

#endregion

## Returns the number of layers in the pattern.
func get_layer_count() -> int:
	return $LayersContainer.get_child_count()

## @experimental: File I/O is not done yet.
## Serializes the canvas.
func serialize():
	var data = {}
	
	data.get_or_add("size_x", bounding_rect.size.x)
	data.get_or_add("size_y", bounding_rect.size.y)
	
	var layers = []
	for child in $LayersContainer.get_children():
		layers.append(child.serialize())
	
	data.get_or_add("layers", layers)
	return data

## @experimental: File I/O is not done yet.
## Deserializes the canvas.
func deserialize(data: Dictionary):
	active_layer = null
	for layer in $LayersContainer.get_children():
		remove_layer(layer)
	
	var size_x = data["size_x"]
	var size_y = data["size_y"]
	bounding_rect = Rect2i(0, 0, size_x, size_y)
	
	for layer in data["layers"]:
		var child = layer_scene.instantiate() as XStitchMasterLayer
		child.deserialize(layer)
		add_layer(child)
