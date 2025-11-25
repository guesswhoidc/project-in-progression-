extends Control

@export var hour_label : Label 
@export var minutes_label : Label
@export var health_bar :  ProgressBar
@export var stamina_bar : ProgressBar
@export var hunger_bar : ProgressBar

var hunger := 0.0: 
	set(new_value):
		if hunger == new_value:
			return
		hunger = new_value
		_update_display(hunger_bar, new_value)

var health := 0.0: 
	set(new_value):
		if health == new_value:
			return
		health = new_value
		_update_display(health_bar, new_value)

var stamina := 0.0: 
	set(new_value):
		if new_value == stamina:
			return
		stamina = new_value
		_update_display(stamina_bar, new_value)

func _update_display(bar: ProgressBar, new_value: float):
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(bar, "value", new_value, 0.5)
	
func _ready():
	assert(hour_label, "on HUD please make sure there is a node on the hour lable")
	assert(minutes_label, "on HUD please make sure there is a node on the minutes lable")
	assert(health_bar, "on HUD please make sure there is a node on the health bar")
	assert(stamina_bar, "on HUD please make sure there is a node on the stealth bar")
	assert(hunger_bar, "on HUD please make sure there is a node on the hunger bar")
