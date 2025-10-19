extends Node3D

@export_file("*.tscn") var gameplay_scene_path

func _ready():
	%MainMenu.start_game.pressed.connect(func():
		assert(gameplay_scene_path, "Please set a gameplay scene to be loaded.")
		var gameplay_scene : PackedScene = load(gameplay_scene_path)
		var node := gameplay_scene.instantiate()
		%Gameplay.add_child(node)
		%MainMenu.hide()
	)
