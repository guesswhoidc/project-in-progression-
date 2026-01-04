class_name CharacterStateData extends Resource

const BASE_HP : float = 10
const BASE_STAMINA : float = 10
const BASE_HUNGER : float = 10

const HUNGER_LOSS_TICK := 0.01
const STAMINA_GAIN_TICK := 0.1

@export var name := "Character"
@export var hp := BASE_HP:
	set(health):
		hp = health
		health_changed.emit(hp)

@export var base_hp := BASE_HP
@export var base_hunger := BASE_HUNGER
@export var hunger := BASE_HUNGER
@export var base_stamina := BASE_STAMINA
@export var stamina := BASE_STAMINA
@export var attack := SkillData.new(0)
@export var ranged := SkillData.new(0)
@export var defense := SkillData.new(0)
@export var gathering := SkillData.new(0)
@export var crafting := SkillData.new(0)
@export var hunting := SkillData.new(0)

signal health_changed(up : float)

func _init():
	if !attack:
		attack = SkillData.new(0)
	if !ranged:
		ranged = SkillData.new(0)
	if !defense:
		defense = SkillData.new(0)
	if !gathering:
		gathering = SkillData.new(0)
	if !crafting:
		crafting = SkillData.new(0)
	if !hunting:
		hunting = SkillData.new(0)

func minute_tick(delta: float):
	hunger = max(0, hunger - (delta * HUNGER_LOSS_TICK))
	stamina = min(BASE_STAMINA, stamina + (delta * STAMINA_GAIN_TICK))

func attack_obj() -> Attack:
	return Attack.new(Combat.DamageType.PHYSICAL, attack.current_level, 50)

func defense_obj() -> Defense:
	return Defense.new(Combat.DamageType.PHYSICAL, defense.current_level, 0)
