extends CharacterBody3D

const ASCENSION_TIME = .2
var speed = 300
var jump_strength = 300
var current_ascension_timeout = 0
var direction := Vector2()
var gravity := Vector3.DOWN * 300
var last_tween : Tween = null
@onready var animations = $Model/AnimationTree["parameters/playback"]

	
func _input(event):
	direction = Input.get_vector("player_left","player_right","player_up","player_down" )
	if !direction.is_zero_approx():
		$Model.rotation.y = -(direction.angle() - (PI/2))
		animations.travel("Walk")
	else:
		animations.travel("Idle")
	
func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, 0, direction.y) * speed * delta
	if Input.is_action_pressed("player_interact") && is_on_floor():
		current_ascension_timeout = ASCENSION_TIME
	if current_ascension_timeout > 0.0:
		velocity += Vector3.UP * jump_strength * delta
		current_ascension_timeout -= delta
	elif !is_on_floor():
		velocity += gravity * delta
	move_and_slide()
