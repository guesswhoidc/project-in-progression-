extends Node

signal tick

const TICK_DURATION = 0.6
var current_tick := TICK_DURATION

func _process(delta: float) -> void:
	current_tick -= delta
	if current_tick <= 0:
		current_tick = TICK_DURATION
		tick.emit()
