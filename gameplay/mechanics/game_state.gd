extends Node

@export var player_body : CharacterBody3D
@export var main_player := CharacterStateData.new()
@export var main_inventory := Inventory.new()
@export_range(0, 14400) var minute_of_day = 0
var game_time = GameTime.new()

signal time_changed(new_time:float)	

func _ready():
	assert(player_body)
	player_body.character_data = main_player
	main_player.health_changed.connect(func(_hp):
		update_vitals()
	)

func _process(delta : float):
	minute_of_day += delta
	minute_of_day = wrapf(minute_of_day, 0, GameTime.MIDNIGHT_TIME)
	main_player.minute_tick(delta)
	update_vitals()
	time_changed.emit(minute_of_day)
	game_time.time = minute_of_day
	%Hud.minutes_label.text = "%02d" % game_time.minutes()
	%Hud.hour_label.text = "%02d" % game_time.hours()
	update_inventory_display()

func update_vitals():
	%Hud.health = (main_player.hp / main_player.base_hp) * 100
	%Hud.stamina = (main_player.stamina / main_player.base_stamina) * 100
	%Hud.hunger = (main_player.hunger / main_player.base_hunger) * 100

func update_inventory_display():
	for i in range(main_inventory.items.size()):
		var slot = %OnScreenMenu.item_slots[i]
		var item = main_inventory.items[i]
		if !item or !slot:
			continue
		slot.amount = item.amount
		slot.display_name = item.item_type.name
		slot.texture = item.item_type.icon
	
	
