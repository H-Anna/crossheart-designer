class_name XStitchThread
extends Resource

@export var brand : String
@export var id : String
@export var color_name : String
@export var color : Color = Color.MAGENTA

func get_identifying_name() -> String :
	return brand + id;
