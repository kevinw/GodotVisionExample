extends CharacterBody3D

@onready var character_meshes = $character_meshes

const MOVE_SPEED = 2
const JUMP_FORCE = 30
const GRAVITY = -9.8
const MAX_FALL_SPEED = 30

var y_velocity = 0
var target: Area3D = null

func _ready():
	pass

func target_reached():
	target = null
	character_meshes.animation_player.play("RESET")

func set_target(new_target: Area3D):
	if not target == null:
		target.active = false
	target = new_target

func _process(delta):
	velocity = Vector3(0, -5, 0)
	if is_on_floor() and not target == null:
		character_meshes.animation_player.play("walk")
		var move_vector = (target.global_position - position).normalized()
		character_meshes.look_at(Vector3(target.global_position.x, position.y, target.global_position.z))
		velocity.x = move_vector.x * MOVE_SPEED
		velocity.z = move_vector.z * MOVE_SPEED
	move_and_slide()
