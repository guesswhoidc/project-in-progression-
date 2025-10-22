extends FileDialog

var current_row: Node

func _ready():
	file_selected.connect(func(path):
		if current_row:
			assert(current_row.has_method("set_icon_path"), "Can't update image because the selected item row node is invalid.")
			current_row.set_icon_path(path)
	)
	canceled.connect(func():
		current_row = null
	)

func pick_icon_for(item_row):
	current_row = item_row
	popup()
	
