extends WorldEnvironment
@export var day_colors := Gradient.new()
@export var current_color := Color("54b8e0"):
	set(new_color):
		current_color = new_color
		environment.background_color = new_color
		environment.fog_light_color = new_color
		
func _ready() -> void:
	%GameState.time_changed.connect(func(time):
		current_color = day_colors.sample(time / GameTime.MIDNIGHT_TIME)
	)
