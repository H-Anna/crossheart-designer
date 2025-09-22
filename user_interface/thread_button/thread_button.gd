@icon("res://icons/thread_green.svg")
class_name ThreadButton
extends Button

## A UI button associated with a [XStitchThread]. When a thread is assigned,
## the button themes change during runtime to reflect the color of the thread.

## The thread assigned to this button.
var thread: XStitchThread:
	set = set_thread

## The stylebox overrides to set.
var styleboxes = [
	"hover",
	"normal",
	"pressed"
]

## The theme color overrides to set.
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

## Assign a thread to this button, then sets up theme overrides.
func set_thread(value: XStitchThread) -> void:
	thread = value
	tooltip_text = thread.color_name
	
	if thread.symbol != null:
		set_button_icon(thread.symbol.data)
	
	set_theme_overrides()

## Calculates the icon color based on the background color luminance.
func get_icon_color() -> Color:
	var luminance = thread.color.get_luminance()
	if luminance > 0.5:
		return Color.BLACK
	else:
		return Color.WHITE

## Overrides theme settings set in [member styleboxes] and [member theme_color_overrides].
func set_theme_overrides() -> void:
	for setting in styleboxes:
		var stylebox := get_theme_stylebox(setting).duplicate()
		stylebox.bg_color = thread.color
		add_theme_stylebox_override(setting, stylebox)
	
	var icon_color = get_icon_color()
	for setting in theme_color_overrides:
		add_theme_color_override(setting, icon_color)

## Emits [member SignalBus.thread_button_clicked]. For effects, see [PaletteController].
func _on_pressed() -> void:
	SignalBus.thread_button_clicked.emit(thread, self, get_parent())
