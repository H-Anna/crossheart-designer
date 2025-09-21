class_name XStitchThread
extends Resource

## Represents a cross stitch thread with a color and an assigned symbol.

## The thread brand.
@export var brand : String

## The thread ID, given by the manufacturer.
@export var id : String

## The name of the color, given by the manufacturer.
@export var color_name : String

## The RGB color of the thread.
@export var color : Color = Color.MAGENTA

## The [XStitchSymbol] assigned to this thread.
var symbol : XStitchSymbol:
	set = set_symbol

## Returns the full unique name for this thread, eg. "DMC310".
func get_identifying_name() -> String :
	return brand + id;

## When setting the symbol for this thread, marks the old symbol as unassigned
## and the new symbol as assigned.
func set_symbol(value: XStitchSymbol) -> void:
	if symbol != null:
		symbol.assigned = false
	
	if value != null:
		value.assigned = true
	symbol = value
