extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = Settings.display_touch_buttons
	Settings.display_touch_buttons_changed.connect(func(display):
		visible = display
	)
