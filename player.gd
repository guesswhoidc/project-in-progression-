extends CharacterBody3D

var speed = 300
var direction := Vector2()
var gravity := Vector3.DOWN * 10
var last_tween : Tween = null
@onready var animations = $Model/AnimationTree["parameters/playback"]

	
func _input(_event):
	direction = Input.get_vector("player_left","player_right","player_up","player_down" )
	if !direction.is_zero_approx():
		$Model.rotation.y = -(direction.angle() - (PI/2))
		animations.travel("Walk")
	else:
		animations.travel("Idle")
func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, 0, direction.y) * speed * delta
	if !is_on_floor():
		velocity += gravity
	move_and_slide()
