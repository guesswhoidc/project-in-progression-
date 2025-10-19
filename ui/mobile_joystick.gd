class_name MobileJoystick extends Control

enum ScreenSide {
	LEFT,
	RIGHT,
	UP,
	DOWN,
	ALL
}

var touch_index : int = -1
var pressed := false
var start_drag_position := Vector2.ZERO
var direction := Vector2.ZERO
@export var max_length := 100
@export var input_left : StringName = "player_left"
@export var input_right : StringName = "player_right"
@export var input_up : StringName = "player_down"
@export var input_down : StringName = "player_up"
@export var side : ScreenSide = ScreenSide.LEFT
@export var outer_circle : Control
@export var inner_circle : Control

func _ready():
	assert(outer_circle, "please set outer_circle node for mobile control")
	assert(inner_circle, "please set inner_circle node for mobile control")
	outer_circle.visible = false
	inner_circle.visible = false
	outer_circle.size = Vector2(max_length, max_length) * 2
	inner_circle.size = Vector2(max_length, max_length)

func _input(event: InputEvent) -> void:
	match event.get_class():
		"InputEventScreenDrag":
			on_drag(event)
			update_joystick()
		"InputEventScreenTouch":
			on_touch(event)
			update_joystick()

func on_touch(event : InputEventScreenTouch):
	if touch_index != event.index && pressed:
		return
	match side:
		ScreenSide.LEFT:
			if event.pressed && event.position.x > get_viewport_rect().size.x / 2:
				return
		ScreenSide.RIGHT:
			if event.pressed && event.position.x < get_viewport_rect().size.x / 2:
				return
		ScreenSide.UP:
			if event.pressed && event.position.y > get_viewport_rect().size.y / 2:
				return
		ScreenSide.DOWN:
			if event.pressed && event.position.y < get_viewport_rect().size.y / 2:
				return
	pressed = event.pressed
	touch_index = event.index
	start_drag_position = event.position

func on_drag(event : InputEventScreenDrag):
	if touch_index != event.index:
		return
	direction = (event.position - start_drag_position).limit_length(max_length) / max_length

func update_joystick():
	if pressed:
		outer_circle.visible = true
		inner_circle.visible = true
		outer_circle.position = start_drag_position - (outer_circle.size / 2)
		inner_circle.position = start_drag_position + (direction * max_length) - (inner_circle.size / 2)
		Input.action_press(input_left, abs(min(direction.x, 0)))
		Input.action_press(input_right, max(direction.x, 0))
		Input.action_press(input_down, abs(min(direction.y, 0)))
		Input.action_press(input_up, max(direction.y, 0))
	else:
		outer_circle.visible = false
		inner_circle.visible = false
		Input.action_release(input_up)
		Input.action_release(input_down)
		Input.action_release(input_left)
		Input.action_release(input_right)
