class_name CharacterStateData extends Resource

const BASE_HP : float = 10
const BASE_STAMINA : float = 10
const BASE_HUNGER : float = 10

@export var name := "Character"
@export var base_hp := BASE_HP
@export var base_hunger := BASE_HUNGER
@export var base_stamina := BASE_STAMINA
@export var attack := SkillData.new(0)
@export var ranged := SkillData.new(0)
@export var defense := SkillData.new(0)
@export var gathering := SkillData.new(0)
@export var crafting := SkillData.new(0)
@export var hunting := SkillData.new(0)

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
