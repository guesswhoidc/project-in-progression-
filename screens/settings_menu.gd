extends Control

@export var display_touch_ui : CheckButton
@export var mute_music : CheckBox
@export var mute_sfx : CheckBox
@export var music_slider : Slider
@export var sfx_slider : Slider
@export var go_back_button : Button

func _ready() -> void:
	assert(display_touch_ui)
	assert(mute_music)
	assert(mute_sfx)
	assert(music_slider)
	assert(sfx_slider)
	assert(go_back_button)
	
	display_touch_ui.button_pressed = Settings.display_touch_buttons
	music_slider.value = Settings.music_volume * 100
	mute_music.button_pressed = Settings.music_mute
	sfx_slider.value = Settings.sfx_volume * 100
	mute_sfx.button_pressed = Settings.sfx_mute
	
	display_touch_ui.toggled.connect(func(value):
		Settings.display_touch_buttons = value
		Settings.save_settings()
	)
	music_slider.value_changed.connect(func(value):
		Settings.music_volume = value * 0.01
		Settings.save_settings()
	)
	mute_music.toggled.connect(func(value):
		Settings.music_mute = value
		Settings.save_settings()
	)
	sfx_slider.value_changed.connect(func(value):
		Settings.sfx_volume = value * 0.01
		Settings.save_settings()
	)
	mute_sfx.toggled.connect(func(value):
		Settings.sfx_mute = value
		Settings.save_settings()
	)
