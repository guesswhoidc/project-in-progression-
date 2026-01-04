class_name ItemDB extends Resource

const CURRENT_VERSION = 1

@export var current_item_index : int = 0
@export var item_types : Array[ItemType] = []

func get_next_item_index():
	current_item_index += 1
	return current_item_index

static func from_dict(dict : Dictionary) -> ItemDB:
	var db := ItemDB.new()
	var version : int = dict.get("version", -1)
	if CURRENT_VERSION != version:
		print("WARNING: loading a ItemDB file with a different version than the current one, this may cause issues.")
		print("file version is: ", version, " expected:", CURRENT_VERSION)
	db.current_item_index = dict["current_item_index"]
	db.items = dict.get("item_types", []).map(ItemType.from_dict)
	return db

func to_dict() -> Dictionary:
	var dict := {}
	dict["version"] = CURRENT_VERSION
	dict["item_types"] = item_types.map(func(type):
		return type.to_dict()
	)
	return dict
