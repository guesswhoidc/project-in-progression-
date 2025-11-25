extends CharacterBody3D

enum States {
	DEFAULT,
	COMBAT
}
const ASCENSION_TIME = .3
const ATTACK_COOLDOWN = .6

# Movement
var speed = 300
var jump_strength = 300
var current_ascension_timeout = 0
var direction := Vector2()
var gravity := Vector3.DOWN * 300
var last_tween : Tween = null

# Combat
var character_data : CharacterStateData
var attack_count_down := ATTACK_COOLDOWN
var state : States = States.DEFAULT
var combat_target = null
var combat_target_data : UnitCombatData
@onready var animations = $Model/AnimationTree["parameters/playback"]
@export var interaction_range : Area3D

func _ready() -> void:
	assert(character_data)

func _process(delta : float) -> void:
	direction = Input.get_vector("player_left","player_right","player_up","player_down" )
	attack_count_down = max(0, attack_count_down - delta)
	match state:
		States.DEFAULT:
			_process_default(delta)
		States.COMBAT:
			_process_combat(delta)

func _process_default(delta : float) -> void:
	if !direction.is_zero_approx():
		#$Model.rotation.y = -(direction.angle() - (PI/2))
		var pos = $Model.position
		#$Model.look_at_from_position(Vector3.ZERO, Vector3(-direction.x, 0, -direction.y) * 10)
		$Model.look_at(Vector3(pos.x - direction.x,0,pos.z - direction.y) * 100)
		$Model.position = pos
		animations.travel("Walk")
	elif Input.is_action_pressed("player_interact"):
		var targets := interaction_range.get_overlapping_areas()
		if targets.size() == 0:
			return
		combat_target = targets[0].get_meta("unit_node")
		combat_target_data = targets[0].get_meta("combat_data")
		combat_target.set_target(self)
		combat_target.set_target_data(character_data)
		state = States.COMBAT
	else:
		animations.travel("Idle")

func _process_combat(delta : float) -> void:
	if !direction.is_zero_approx():
		state = States.DEFAULT
		return
	if attack_count_down > 0:
		return
	$Model.look_at(Vector3(combat_target.position.x, 0, combat_target.position.z))
	$Model.rotation.x = 0
	$Model.rotation.z = 0
	$Model.rotation.y -= deg_to_rad(180)
	attack_count_down = ATTACK_COOLDOWN
	animations.travel("Punch")
	var result : Combat.CombatResolution = character_data.attack_obj().resolve(combat_target_data.defense_obj())
	if result.type == Combat.ResolutionType.HIT:
		combat_target_data.hp -= result.damage
		if combat_target_data.hp <= 0:
			state = States.DEFAULT
			return
		print("Damage :", result.damage)
	else:
		print(result)

func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, 0, direction.y) * speed * delta
	if Input.is_action_pressed("player_jump") && is_on_floor():
		current_ascension_timeout = ASCENSION_TIME
	if current_ascension_timeout > 0.0:
		velocity += Vector3.UP * jump_strength * delta
		current_ascension_timeout -= delta
	elif !is_on_floor():
		velocity += gravity * delta
	move_and_slide()
