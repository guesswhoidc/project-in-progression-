class_name MobileButtonToAction extends Button
var touch_index := -1
@export var action: StringName = "ui_accept"
func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_index = event.index
			button_pressed = true
		elif touch_index == event.index:
			button_pressed = false
func _ready():
	toggled.connect(func(active):
		if active:
			Input.action_press(action)
		else:
			Input.action_release(action)
	)
