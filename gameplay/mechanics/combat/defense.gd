
class_name Defense extends Resource

@export var type : Combat.DamageType = Combat.DamageType.PHYSICAL
@export var defense : float = 0
@export var dodge : float = 0 

static var EMPTY : Defense = Defense.new(Combat.DamageType.PHYSICAL, 0, 0)

func _init(t : Combat.DamageType, def: float, dodge_chance : float):
	type = t
	defense = def
	dodge = dodge_chance

func resolve(attack: Attack) -> Combat.CombatResolution:
	return Combat.resolve(attack, self)
