class_name XStitchTool
extends Resource

## A tool that describes a method of interaction with the
## [XStitchCanvas] (among others), as well as change how the
## cursor looks.

## Helps identify the purpose of the selected tool.
enum Method { DRAW_ERASE, COLOR_PICK, FILL, BACKSTITCH }

## The method this tool uses.
## Classes that interact with tools can query this property
## without having to reference the exact resource file to compare.
@export var method: Method

## Whether the [XStitchCursorLayer] should be enabled when this
## tool is selected.
@export var enable_cursor_layer: bool

## Custom mouse cursor image shown when this tool is selected.[br]
## Please choose a file in an image format!
@export var cursor_image: Resource

## Custom mouse cursor hotspot.
@export var cursor_hotspot: Vector2
