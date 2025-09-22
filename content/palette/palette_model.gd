class_name PaletteModel
extends Resource

## Holds data related to the [XStitchThread]s added to the
## pattern.

## The array of threads present in the palette.
@export var threads : Array[XStitchThread]

## The index of the selected thread.
var selected : int = -1
