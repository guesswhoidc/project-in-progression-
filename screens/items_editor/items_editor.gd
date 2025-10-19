class_name ItemEditor extends Control

const ITEMS_PATH = "res://gameplay_assets/items"

var item_row_scene := preload("res://screens/items_editor/item_row.tscn")
@onready var items_list := $MarginContainer/VBoxContainer/ItemsList
@onready var create_item := $MarginContainer/VBoxContainer/CreateItem
@onready var confirm = $ConfirmationDialog
static var items_folder : DirAccess
func _ready():
	items_folder = DirAccess.open(ITEMS_PATH)
	for filename in items_folder.get_files():
		var file : ItemType = load(ITEMS_PATH + "/" + filename)
		var item_instance = item_row_scene.instantiate()
		item_instance.update_display(file)
		item_instance.confirm_dialog = $ConfirmationDialog
		items_list.add_child(item_instance)
	
	create_item.pressed.connect(func():
		var item_instance = item_row_scene.instantiate()
		item_instance.confirm_dialog = $ConfirmationDialog
		items_list.add_child(item_instance)
	)
