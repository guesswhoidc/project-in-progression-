extends HBoxContainer

var item_type : ItemType
var file_path : String
var confirm_dialog : ConfirmationDialog
var file_select_dialog : FileDialog

func prepare(confirm : ConfirmationDialog, file_dialog: FileDialog):
	confirm_dialog = confirm
	file_select_dialog = file_dialog
	assert(confirm_dialog, "No Confirm Dialog Present")
	assert(file_select_dialog, "No File Select Present")

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
	$FileName.text = file_path.split("/")[-1].split(".")[0]
	$Name.text = type.name
	$Icon.icon = type.icon
	$StackSize.value = type.stack_size

func save_item_type():
	var err := ResourceSaver.save(
		item_type
	)
	assert(err == OK, "Couldn't save the item type, got error: " + str(err) + " " + error_string(err))

func _ready():
	if !item_type:
		create_item()
	bind_events()


func bind_events():
	$FileName.text_changed.connect(func(name):
		var old_file_path := item_type.resource_path
		
		file_path = (
			ItemEditor.ITEMS_PATH +
			"/" + name.to_camel_case() +
			".item_type.tres"
		)
		if ItemEditor.items_folder.file_exists(old_file_path):
			var err := ItemEditor.items_folder.rename(old_file_path, file_path)
			assert(err == OK, "Got a error when renaming a file, error: " + error_string(err))
		item_type.take_over_path(file_path)	
	)
	
	$Name.text_changed.connect(func(name):
		item_type.name = name

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
	
	$Icon.pressed.connect(func():
		file_select_dialog.pick_icon_for(self)
	)

func set_icon_path(path: String):
	var icon : Texture = load(path)
	$Icon.icon = icon
	item_type.icon = icon
	save_item_type()

func delete_self():
	ItemEditor.items_folder.remove(file_path)
	free.call_deferred()
