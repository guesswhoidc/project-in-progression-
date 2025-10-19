extends Control

@onready var item_toggle = $HBoxContainer/Button
@onready var inventory = $Window
@onready var item_slots = $Window/Panel/MarginContainer/VBoxContainer/GridContainer.get_children()
@onready var last_inventory_position := (get_viewport().get_visible_rect().size / 2) + Vector2(inventory.size.x, -inventory.size.y/2)

func _ready():
	item_toggle.pressed.connect(toggle_inventory)
	inventory.close_requested.connect(toggle_inventory)

func toggle_inventory():
	if inventory.visible:
		last_inventory_position = inventory.position
		inventory.visible = false
	else:
		inventory.visible = true
		inventory.position = last_inventory_position
