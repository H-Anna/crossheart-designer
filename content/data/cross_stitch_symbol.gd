class_name XStitchSymbol
extends Resource

## An SVG symbol that can be assigned to an [XStitchThread]. This is an accessibility
## feature in all cross stitch patterns that lets the user tell different stitches
## apart even on a black-and-white pattern print or in case of color vision disability.

## The ID of this symbol.
@export var id : String

## The name of this symbol, eg. the shape it represents.
@export var symbol_name : String

## The SVG image of the symbol.
@export var data : CompressedTexture2D

## Whether this symbol is already assigned to an [XStitchThread].
var assigned := false

## Returns the full unique name for this symbol. (Currently only returns the [member id].)
func get_identifying_name() -> String :
	return id;
