class_name ItemEditor extends Control

const ITEMS_PATH = "res://gameplay_assets/items"

var item_row_scene := preload("res://screens/items_editor/item_row.tscn")
@onready var items_list := $MarginContainer/VBoxContainer/ItemsList
@onready var create_item := $MarginContainer/VBoxContainer/CreateItem
@onready var confirm = $ConfirmationDialog
static var items_folder : DirAccess
func _ready():
	items_folder = DirAccess.open(ITEMS_PATH)
	var item_types := Array(items_folder.get_files()).map(func(filename) -> ItemType:
		return load(ITEMS_PATH + "/" + filename)
	)
	item_types.sort_custom(func(a, b):
		return a.order > b.order
	)
	
	var i = 0
	for file in item_types:
		i += 1
		var item_instance = item_row_scene.instantiate()
		item_instance.update_display(file)
		item_instance.prepare($ConfirmationDialog, $FileDialog)
		if i != file.order:
			file.order = i
			item_instance.save_item_type.call_deferred()
		items_list.add_child(item_instance)
	
	create_item.pressed.connect(func():
		var item_instance = item_row_scene.instantiate()
		item_instance.prepare($ConfirmationDialog, $FileDialog)
		items_list.add_child(item_instance)
	)
