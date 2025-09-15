class_name XStitchThread
extends Resource

@export var brand : String
@export var id : String
@export var color_name : String
@export var color : Color = Color.MAGENTA
var symbol : XStitchSymbol: set = set_symbol

func get_identifying_name() -> String :
	return brand + id;

## When setting the symbol for this thread, marks the old symbol as unassigned
## and the new symbol as assigned.
func set_symbol(value: XStitchSymbol):
	if symbol != null:
		symbol.assigned = false
	
	if value != null:
		value.assigned = true
	symbol = value
