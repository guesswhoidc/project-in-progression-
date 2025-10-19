class_name ItemType extends Resource

@export var icon : Texture
@export var name : String = "Item"
@export var stack_size : int = 1
@export var description := ""
@export var order : int = 9999 # Cool future bug to solve in case of 10k files
