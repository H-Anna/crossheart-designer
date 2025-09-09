@icon("res://icons/ThreadButton.svg")
class_name ThreadButton
extends Button

var thread: XStitchThread
var icon_color: Color

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

## Set the context menu to the right mouse button click.
func set_context_menu(context_menu: Node) -> void:
	$RMB.context_menu = context_menu

## Assign a thread to this button.
func assign_thread(_thread: XStitchThread) -> void:
	thread = _thread
	tooltip_text = thread.color_name
	icon_color = get_icon_color()
	set_theme_overrides()

## Calculate the icon luminance based on the background color.
## Produces a black or white icon
func get_icon_color() -> Color:
	var luminance = thread.color.get_luminance()
	if luminance > 0.5:
		return Color.BLACK
	else:
		return Color.WHITE

func set_theme_overrides():
	for setting in styleboxes:
		var stylebox := get_theme_stylebox(setting).duplicate()
		stylebox.bg_color = thread.color
		add_theme_stylebox_override(setting, stylebox)
	
	for setting in theme_color_overrides:
		add_theme_color_override(setting, icon_color)


func _on_pressed() -> void:
	SignalBus.thread_button_clicked.emit(thread, self, get_parent())
