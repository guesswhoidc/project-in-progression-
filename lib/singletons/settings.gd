extends Node

const MUSIC_BUS = "Music"
const SFX_BUS = "Sound Effects"
const SETTINGS_FILE = "user://settings.json"
const SETTINGS_VERSION = 1

var music_volume : float = 1.0:
	set(volume):
		music_volume = volume
		update_bus(MUSIC_BUS, volume)
var sfx_volume : float = 1.0:
	set(volume):
		sfx_volume = volume
		update_bus(SFX_BUS, volume)
var music_mute := false:
	set(m):
		music_mute = m
		set_bus_mute(MUSIC_BUS, m)
var sfx_mute := false:
	set(m):
		sfx_mute = m
		set_bus_mute(SFX_BUS, m)
var display_touch_buttons := true:
	set(display):
		display_touch_buttons = display
		display_touch_buttons_changed.emit(display)


signal display_touch_buttons_changed(bool)

func update_bus(bus_name: String, volume: float) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_linear(bus, volume)

func set_bus_mute(bus_name: String, mute: bool) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus, mute)

func save_settings():
	var dict := {
		"settings_version": SETTINGS_VERSION,
		"display_touch_buttons": display_touch_buttons,
		"music_volume" : music_volume,
		"music_mute" : music_mute,
		"sfx_volume": sfx_volume,
		"sfx_mute": sfx_mute,
	}
	var json := JSON.stringify(dict)
	var save_file := FileAccess.open(SETTINGS_FILE, FileAccess.WRITE)
	save_file.store_string(json)
	save_file.close()

func load_settings():
	var save_file := FileAccess.open(SETTINGS_FILE, FileAccess.READ)
	if !save_file:
		return
	var dict : Dictionary = JSON.parse_string(save_file.get_as_text())
	if dict.get("settings_version", null) != SETTINGS_VERSION:
		print("loading incompatible settings file.")
		print("errors may occur")
	music_volume = dict.get("music_volume", music_volume)
	music_mute = dict.get("music_mute", music_mute)
	sfx_volume = dict.get("sfx_volume", sfx_volume)
	sfx_mute = dict.get("sfx_mute", sfx_mute)
	display_touch_buttons = dict.get("display_touch_buttons", display_touch_buttons)

func _ready():
	var os_name := OS.get_name()
	display_touch_buttons = (os_name == "Android" or os_name == "iOS")
	load_settings()
