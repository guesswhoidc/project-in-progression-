extends Node

@export var main_player := CharacterStateData.new()
@export var main_inventory := Inventory.new()
@export_range(0, 14400) var minute_of_day = 0
var game_time = GameTime.new()

signal time_changed(new_time:float)	

func _process(delta : float):
	minute_of_day += delta * 10
	minute_of_day = wrapf(minute_of_day, 0, GameTime.MIDNIGHT_TIME)
	time_changed.emit(minute_of_day)
	game_time.time = minute_of_day
	%Hud.minutes_label.text = "%02d" % game_time.minutes()
	%Hud.hour_label.text = "%02d" % game_time.hours()
	update_inventory_display()

func update_inventory_display():
	for i in range(main_inventory.items.size()):
		var slot = %OnScreenMenu.item_slots[i]
		var item = main_inventory.items[i]
		if !item or !slot:
			continue
		slot.amount = item.amount
		slot.display_name = item.item_type.name
		slot.texture = item.item_type.icon
	
	
	
