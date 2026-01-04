class_name Combat extends Object

enum DamageType {
	PHYSICAL
}

enum ResolutionType {
	DODGE,
	HIT,
	MISS,
}

class CombatResolution:
	static var MISS = CombatResolution.new(ResolutionType.MISS, 0)
	static var DODGE = CombatResolution.new(ResolutionType.DODGE, 0)
	var type : ResolutionType
	var damage : float = 0

	func _init(t : ResolutionType, dmg : float) -> void:
		type = t
		damage = dmg
	
	static func hit(damage: float) -> CombatResolution:
		return CombatResolution.new(
			ResolutionType.HIT,
			damage
		)

## Hit chance can't ever get lower than this
const PITY_PERCENTAGE := 10
## Minimun damage a attack can deal
const PITY_HIT_DAMAGE := 0.1
## Will hit if the d100 roll is lower than this number
const BASE_HIT_CHANCE := 50
static var rng := RandomNumberGenerator.new()

static func resolve(attack : Attack, defense: Defense) -> CombatResolution:
	assert(attack)
	assert(defense)
	var hit_roll := rng.randf_range(0,100)
	var chance_modifier := (attack.accuracy * 0.5) - (defense.dodge * 0.5)
	var did_hit : bool = (hit_roll <= max(PITY_PERCENTAGE, BASE_HIT_CHANCE + chance_modifier))
	if did_hit:
		return CombatResolution.hit(
			max(
				PITY_HIT_DAMAGE, 
				attack.attack - defense.defense * 0.5
			)
		)
	elif chance_modifier < 0 && hit_roll-BASE_HIT_CHANCE < -chance_modifier:
		return CombatResolution.DODGE	
	return CombatResolution.MISS
