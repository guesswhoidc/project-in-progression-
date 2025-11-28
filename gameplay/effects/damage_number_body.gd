extends RigidBody3D

signal finished 

const DESPAWN_TIME = 1.0

var timeout := DESPAWN_TIME

func prepare(result : Combat.CombatResolution):
	$CollisionShape3D/Sprite3D/SubViewport/DamageBubble.prepare(result)
	timeout = DESPAWN_TIME
	process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	timeout -= delta
	if timeout <= 0:
		finished.emit()
		process_mode = Node.PROCESS_MODE_DISABLED
