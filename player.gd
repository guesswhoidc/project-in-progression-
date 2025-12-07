extends CharacterBody3D

enum States {
	DEFAULT,
	COMBAT
}
const ASCENSION_TIME = .3
const ATTACK_COOLDOWN = .6

# Movement
var speed = 6
var jump_strength = 3
var current_ascension_timeout = 0
var direction := Vector2()
var gravity := Vector3.DOWN * 3
var last_tween : Tween = null

# Visual
var looking_direction := Vector3.BACK * 100


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
		update_direction(Vector3(direction.x, 0, direction.y) * 100)
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
	update_direction(Vector3(combat_target.position.x, 0, combat_target.position.z))
	attack_count_down = ATTACK_COOLDOWN
	animations.travel("Punch")
	var result : Combat.CombatResolution = character_data.attack_obj().resolve(combat_target_data.defense_obj())
	EffectSpawner.spawn_damage_bubble(self, combat_target, result)
	if result.type == Combat.ResolutionType.HIT:
		combat_target_data.hp -= result.damage
		if combat_target_data.hp <= 0:
			state = States.DEFAULT


func _physics_process(delta: float) -> void:
	velocity = Vector3(direction.x, 0, direction.y) * speed 
	if Input.is_action_pressed("player_jump") && is_on_floor():
		current_ascension_timeout = ASCENSION_TIME
	if current_ascension_timeout > 0.0:
		velocity += Vector3.UP * jump_strength
		current_ascension_timeout -= delta
	elif !is_on_floor():
		velocity += gravity 
	move_and_slide()


func update_direction(target : Vector3) -> void:
	if looking_direction == target:
		return
	var tween := create_tween()
	tween.tween_method(func(direction):
		$Model.look_at(Vector3(direction.x, 0, direction.z))
		$Model.rotation.x = 0
		$Model.rotation.z = 0
		$Model.rotation.y -= deg_to_rad(180)	
	,looking_direction, target, 0.3)
	looking_direction = target
