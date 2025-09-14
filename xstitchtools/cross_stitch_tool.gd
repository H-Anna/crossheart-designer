class_name XStitchTool
extends Resource

enum Method {DRAW_ERASE, COLOR_PICK}

@export var method: Method
@export var enable_cursor_layer: bool
## Custom mouse cursor image shown when this tool is selected.
## Please choose an image format!
@export var cursor_image: Resource
@export var cursor_hotspot: Vector2
