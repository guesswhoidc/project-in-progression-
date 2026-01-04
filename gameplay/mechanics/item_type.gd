class_name ItemType extends Resource

@export var id : int = -1
@export var icon : Texture
@export var name : String = "Item"
@export var stack_size : int = 1
@export var description := ""
@export var order : int = 9999 

func to_dict():
	return {
		"id": id,
		"icon": icon.resource_path,
		"name": name, 
		"stack_size": stack_size,
		"description": description,
		"order": order,
	}

static func from_dict(dict: Dictionary) -> ItemType:
	var type = ItemType.new()
	type.id = dict["id"]
	type.icon = load(dict["icon"])
	type.name = dict["name"]
	type.stack_size = dict["stack_size"]
	type.description = dict["description"]
	type.order = dict["order"]
	return type
