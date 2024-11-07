extends Button

var styleboxes = [
	"hover",
	"normal",
	"pressed"
]

var theme_color_overrides = [
		"icon_disabled_color",
		"icon_focus_color",
		"icon_hover_color",
		"icon_hover_pressed_color",
		"icon_normal_color",
		"icon_pressed_color"
	]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	var new_color = Color.from_hsv(randf(), randf(), randf())
	
	for stylebox_name in styleboxes:
		var stylebox := get_theme_stylebox(stylebox_name).duplicate()
		stylebox.bg_color = new_color
		add_theme_stylebox_override(stylebox_name, stylebox)
	
	var icon_color : Color
	var luminance = new_color.get_luminance()
	if luminance > 0.5:
		icon_color = Color.BLACK
	else:
		icon_color = Color.WHITE
	
	for setting in theme_color_overrides:
		add_theme_color_override(setting, icon_color)
