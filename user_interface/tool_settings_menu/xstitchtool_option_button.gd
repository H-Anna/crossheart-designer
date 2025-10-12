extends OptionButton

@export var tool : XStitchTool
@export var metadata_name : StringName

func _ready() -> void:
	set_tool_metadata(selected)

func set_tool_metadata(value: int) -> void:
	tool.set_meta(metadata_name, value)
	print_debug("Metadata set: ", metadata_name, " = ", tool.get_meta(metadata_name))
