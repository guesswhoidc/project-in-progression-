extends RigidBody3D

signal finished 

const DESPAWN_TIME = 1.0

@export var damage_sounds : Array[AudioStream]
var timeout := DESPAWN_TIME

func prepare(result : Combat.CombatResolution):
	$CollisionShape3D/Sprite3D/SubViewport/DamageBubble.prepare(result)
	timeout = DESPAWN_TIME
	process_mode = Node.PROCESS_MODE_INHERIT
	var sound : AudioStream = damage_sounds[randi_range(0, damage_sounds.size()-1)]
	$AudioStreamPlayer3D.stream = sound
	$AudioStreamPlayer3D.play()

func _process(delta: float) -> void:
	timeout -= delta
	if timeout <= 0:
		finished.emit()
		process_mode = Node.PROCESS_MODE_DISABLED
