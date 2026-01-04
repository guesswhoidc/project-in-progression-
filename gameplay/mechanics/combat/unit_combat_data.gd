class_name UnitCombatData extends Resource 

const BASE_HP : float = 10

@export var name :String
@export var hp : float:
	set(health):
		hp = health
		health_changed.emit(health)
@export var base_hp : float
@export var attack : Attack
@export var defense : Defense
@export var attack_cooldown := 2.0
@export var movement_speed := 5.0

signal health_changed(health: float)

func attack_obj() -> Attack:
	if attack:
		return attack
	return Attack.EMPTY
	
func defense_obj() -> Defense:
	if defense:
		return defense
	else:
		return Defense.EMPTY
