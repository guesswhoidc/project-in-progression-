@tool
extends Node3D

@export var combat_data : UnitCombatData
@export var info_height := 0.0:
	set(height):
		info_height = height
		if $Sprite3D:
			$Sprite3D.position.y = info_height
@export var model_scene : PackedScene 
@onready var display = $Sprite3D/SubViewport/UnitInfoDisplay
@export_tool_button("Update preview")
var update_preview_action = update_preview
var target : Node3D
var target_data
var attack_cooldown := 0.0

func update_preview():
	assert(combat_data)
	assert(model_scene)
	var disp = $Sprite3D/SubViewport/UnitInfoDisplay
	disp.name_label.text = combat_data.name
	var health_bar : ProgressBar = display.health_bar
	health_bar.max_value = combat_data.base_hp
	health_bar.value = combat_data.hp
	var model := model_scene.instantiate()
	for child in $Model.get_children():
		child.queue_free()
	$Model.add_child(model)
	$Sprite3D.position.y = info_height

func _ready() -> void:
	update_preview()
	attack_cooldown = combat_data.attack_cooldown
	combat_data.health_changed.connect(func(_hp):
		update_health()
	)
	$Area3D.set_meta("unit_node", self)
	$Area3D.set_meta("combat_data", combat_data)

func _process(delta: float) -> void:
	attack_cooldown = max(0, attack_cooldown - delta)
	if !target:
		return
	$Model.look_at(Vector3(target.position.x, 0, target.position.z))
	$Model.rotation.y -= deg_to_rad(180)
	if attack_cooldown > 0:
		return
	attack_cooldown = combat_data.attack_cooldown
	target_data.hp -= combat_data.attack_obj().resolve(target_data.defense_obj()).damage	

func set_target(t : Node3D):
	target = t

func set_target_data(data):
	target_data = data

func update_health():
	var health_bar : ProgressBar = display.health_bar
	health_bar.max_value = combat_data.base_hp
	health_bar.value = combat_data.hp
	if combat_data.hp <= 0:
		die()

func die():
	queue_free()
