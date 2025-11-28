extends Node3D

var damage_bubble_scene : PackedScene = preload("res://gameplay/effects/damage_number_body.tscn")
var damage_bubble_pool : Array[RigidBody3D]
const DAMAGE_BUBBLE_POOL_SIZE := 100
const IN_USE_META_KEY = "IN_USE"


func _ready():
	for i in DAMAGE_BUBBLE_POOL_SIZE:
		var bubble : RigidBody3D = damage_bubble_scene.instantiate()
		bubble.set_meta(IN_USE_META_KEY, false)
		damage_bubble_pool.append(bubble)

func get_free_bubble() -> Result:
	var res = Result.new()
	for b in damage_bubble_pool:
		if !b.get_meta(IN_USE_META_KEY):
			b.set_meta(IN_USE_META_KEY, true)
			return res.ok(b)
	return res.default_error("couldn't get a free damage bubble, consider resizing the Array during development")

func spawn_damage_bubble(from : PhysicsBody3D, to: PhysicsBody3D, result : Combat.CombatResolution):
	var bubble_result := get_free_bubble()
	bubble_result.assert_succeeded()
	var bubble : RigidBody3D = bubble_result.result()
	var target_parent = to.get_parent()
	target_parent.add_child(bubble)
	bubble.prepare(result)
	bubble.position = to.position
	bubble.position.y += 2
	bubble.linear_velocity = (to.position - from.position).normalized() * 2
	bubble.linear_velocity.y = 2
	await bubble.finished
	bubble.set_meta(IN_USE_META_KEY, false)
	target_parent.remove_child(bubble)
