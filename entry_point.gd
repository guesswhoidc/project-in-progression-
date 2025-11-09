extends Node3D

@export_file("*.tscn") var gameplay_scene_path
@export_file("*.tscn") var tools_scene_path
class GameplayState:
	var on_enter : Callable
	var on_exit : Callable
	func _init(enter: Callable, exit: Callable):
		on_enter = enter
		on_exit = exit

enum States {
	GAMEPLAY,
	TOOLS,
	MAIN_MENU
}

var change_state_to_gameplay := change_state.bind(States.GAMEPLAY)
var change_state_to_tools := change_state.bind(States.TOOLS)

var gameplay_state := GameplayState.new(
	func():
		assert(gameplay_scene_path, "Please set a gameplay scene to be loaded.")
		var gameplay_scene : PackedScene = load(gameplay_scene_path)
		assert(gameplay_scene,"Gameplay scene loading failed, received null, check for errors in the scene dependencies.")
		var node := gameplay_scene.instantiate()
		%Gameplay.add_child(node), 
	func():
		for child in %Gameplay.get_children(): 
			child.queue_free()
)
var main_menu_state := GameplayState.new(
	func():
		%MainMenu.show()
		%MainMenu.start_game.pressed.connect(change_state_to_gameplay)
		%MainMenu.tools.pressed.connect(change_state_to_tools)
		pass,
	func():
		%MainMenu.hide()
		%MainMenu.tools.pressed.disconnect(change_state_to_tools)
		%MainMenu.start_game.pressed.disconnect(change_state_to_gameplay)
		pass
)
var tools_state := GameplayState.new(
	func():
		assert(tools_scene_path, "Tools scene isn't selected propperly")
		var tools_scene : PackedScene = load(tools_scene_path)
		var instance = tools_scene.instantiate()
		%ToolsTarget.add_child(instance)
		(func():
			print("got here")
			instance.exit_button.pressed.connect(change_state.bind(States.MAIN_MENU))	
		).call_deferred()
		pass,
	func():
		%ToolsTarget.get_children().all(func(child): child.queue_free())
		pass
)

var states = {
	States.GAMEPLAY: gameplay_state,
	States.TOOLS: tools_state,
	States.MAIN_MENU: main_menu_state
}

var current_state : States = States.MAIN_MENU

func _ready():
	states[current_state].on_enter.call()
	
func change_state(state : States):
	states[current_state].on_exit.call()
	current_state = state
	states[current_state].on_enter.call()
