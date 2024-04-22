extends Node3D


@export var spring_strength: float = 2.2
@export var manual_spring_factor: bool = false
@onready var audio: AudioStreamPlayer3D = $audio

var bodies = {}
var skeleton: Skeleton3D
var bone_idx: int = -1
var orig_pose_pos: Vector3 = Vector3.ZERO
var physics_factor: float = 1 # how much up the spring is based on physics collisions

func _on_area_3d_body_entered(body):
	if body is RigidBody3D and not bodies.has(body):
		
		var direction: Vector3 = global_basis.y * -body.linear_velocity.y
		body.apply_impulse(direction * spring_strength)
		bodies[body] = true
		
		if audio:
			audio.play()

func _on_area_3d_body_exited(body):
	bodies.erase(body)

func set_spring_factor(value01):
	if skeleton and bone_idx >= 0:
		var newPosePos = orig_pose_pos
		newPosePos.y = orig_pose_pos.y * value01
		skeleton.set_bone_pose_position(bone_idx, newPosePos)
		
func _process(delta: float):
	if manual_spring_factor:
		return
		
	var old_physics_factor = physics_factor
	
	var diff := -11.0 if bodies.size() > 0 else 3.5
	physics_factor = clamp(physics_factor + delta * diff, 0, 1)
	
	if old_physics_factor != physics_factor:
		set_spring_factor(physics_factor)

func _ready():
	var skeletons := find_children("*", "Skeleton3D")
	if skeletons.size() != 1:
		printerr("Expected exactly 1 Skeleton3D under $Spring")
		return
	
	skeleton = skeletons[0] as Skeleton3D
	#skeleton.pose_updated.connect(func():
	#	print("pose updated")
	#)
	
	var topBone := skeleton.find_bone("Top_01")
	if topBone == -1:
		printerr("Could not find Top_01 bone in spring")
		return
		
	bone_idx = topBone
	orig_pose_pos = skeleton.get_bone_pose_position(bone_idx)
