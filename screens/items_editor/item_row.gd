extends HBoxContainer

var item_type : ItemType
var file_path : String
var confirm_dialog : ConfirmationDialog

func create_item():
	item_type = ItemType.new()
	file_path = (
		ItemEditor.ITEMS_PATH + 
		"/" + str(randi()) +
		".item_type.tres"
	)
	item_type.take_over_path(file_path)

func update_display(type : ItemType):
	if !is_node_ready():
		await ready
		item_type = type
	file_path = item_type.resource_path
	$Name.text = type.name
	$Icon.icon = type.icon
	$StackSize.value = type.stack_size

func save_item_type():
	var err := ResourceSaver.save(
		item_type
	)
	assert(err == OK, "Couldn't save the item type, got error: " + error_string(err))

func _ready():
	if !item_type:
		create_item()
	bind_events()


func bind_events():
	$Name.text_changed.connect(func(name):
		item_type.name = name
		var old_file_path := item_type.resource_path
		
		file_path = (
			ItemEditor.ITEMS_PATH +
			"/" + name.to_camel_case() +
			"_" + str(randi()) +
			".item_type.tres"
		)
		if ItemEditor.items_folder.file_exists(old_file_path):
			var err := ItemEditor.items_folder.rename(old_file_path, file_path)
			assert(err == OK, "Got a error when renaming a file, error: " + error_string(err))
		item_type.take_over_path(file_path)
		save_item_type()
	)
	
	$StackSize.value_changed.connect(func(val):
		item_type.stack_size = val
		save_item_type()
	)
	
	$Delete.pressed.connect(func():
		if !confirm_dialog:
			delete_self()
			return
		confirm_dialog.popup()
		var accept : Callable
		var deny : Callable
		accept = func():
			delete_self()
			confirm_dialog.canceled.disconnect(deny)
		deny = func():
			confirm_dialog.confirmed.disconnect(accept)
		confirm_dialog.confirmed.connect(accept, CONNECT_ONE_SHOT)
		confirm_dialog.canceled.connect(deny, CONNECT_ONE_SHOT)
	)

func delete_self():
	ItemEditor.items_folder.remove(file_path)
	free.call_deferred()
