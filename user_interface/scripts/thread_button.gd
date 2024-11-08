@icon("res://icons/ThreadButton.svg")
class_name ThreadButton
extends Button

var thread: Skein:
	set(value):
		thread = value
		_refresh()

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

func _refresh() -> void:
	tooltip_text = thread.color_name
	
	for setting in styleboxes:
		var stylebox := get_theme_stylebox(setting).duplicate()
		stylebox.bg_color = thread.color
		add_theme_stylebox_override(setting, stylebox)
	
	var icon_color : Color
	var luminance = thread.color.get_luminance()
	if luminance > 0.5:
		icon_color = Color.BLACK
	else:
		icon_color = Color.WHITE
	
	for setting in theme_color_overrides:
		add_theme_color_override(setting, icon_color)

func _on_pressed() -> void:
	print("Thread Button pressed: %s" % thread.color_name)
