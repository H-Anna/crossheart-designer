extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.toast_notification.connect(display_message)

func display_message(message: String) -> void:
	$Label.text = message
	show()
	$Timer.start()
	await $Timer.timeout
	hide()
