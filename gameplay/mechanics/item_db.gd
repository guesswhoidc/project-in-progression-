class_name ItemDB extends Resource

const CURRENT_VERSION = 1
const SINGLETON_ITEM_DB_PATH = "res://gameplay_assets/ItemDB.json"

var file : FileAccess
@export var current_item_index : int = 0
@export var item_types : Dictionary[int, ItemType] = {}

static var singleton : ItemDB :
	get:
		if singleton:
			return singleton
		singleton = ItemDB.from_file(FileAccess.open(SINGLETON_ITEM_DB_PATH, FileAccess.READ_WRITE))
		return singleton

func get_next_item_index():
	current_item_index += 1
	return current_item_index

# TODO: This should probably return a Result Object, but
# I will keep this as is, same for from_dict
func load_dict(dict : Dictionary):
	var version : int = dict.get("version", -1)
	if CURRENT_VERSION != version:
		print("WARNING: loading a ItemDB file with a different version than the current one, this may cause issues.")
		print("file version is: ", version, " expected:", CURRENT_VERSION)
	current_item_index = dict.get("current_item_index", 0)
	var types_dict : Dictionary = dict.get("item_types", {})
	for id in types_dict:
		var type := ItemType.from_dict(types_dict[id])
		item_types[id] = type

static func from_file(f : FileAccess) -> ItemDB:
	var db := ItemDB.from_dict(JSON.parse_string(f.get_as_text()))
	db.file = f
	return db

static func from_dict(dict : Dictionary) -> ItemDB:
	var db := ItemDB.new()
	db.load_dict(dict)
	return db

func to_dict() -> Dictionary:
	var dict := {}
	dict["version"] = CURRENT_VERSION
	var types_dict = {}
	for id in item_types:
		types_dict[id] = item_types[id].to_dict()
	dict["item_types"] = types_dict
	return dict

func save() -> Result:
	var saved := file.store_string(JSON.stringify(to_dict()))
	if !saved:
		return Error.new("Couldn't save the Item DB").as_result()
	return Result.new().ok(null)

func get_item_type(id : int) -> ItemType:
	return item_types.get(id)

func create_item_type() -> ItemType:
	var type := ItemType.new()
	type.id = get_next_item_index()
	item_types[type.id] = type
	return type

func delete_item_type(id : int) -> bool:
	return item_types.erase(id)
