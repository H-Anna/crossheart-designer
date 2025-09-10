class_name XStitchSymbol
extends Resource

@export var id : String
@export var symbol_name : String
@export var data : CompressedTexture2D
var assigned := false

func get_identifying_name() -> String :
	return id;
