extends Button

@export var texture : Texture = Texture.new():
	set(tex):
		texture = tex
		update_display_icon.call_deferred()
@export var amount : int = 0:
	set(new_amount):
		amount = new_amount
		update_amount.call_deferred()
@export var display_name : String = ""
@onready var display_icon = $TextureRect
@onready var amount_display = $Panel/Label

func _ready():
	update_amount()
	update_display_icon()

func update_display_icon():
	display_icon.texture = texture

func update_amount():
	$Panel.visible = amount > 1
	amount_display.text = str(amount)
