class_name Attack extends Resource

@export var type : Combat.DamageType = Combat.DamageType.PHYSICAL
@export var attack : float = 0
@export var accuracy : float = 0

static var EMPTY = new(Combat.DamageType.PHYSICAL, 0,0)

func _init(t: Combat.DamageType, atk: float, acc: float) -> void:
	type = t
	attack = atk
	accuracy = acc
	
func resolve(defense: Defense) -> Combat.CombatResolution:
	return Combat.resolve(self, defense)
