extends Node3D

@onready var Spring: Node3D = $Spring
var time: float = 0

const VERBOSE = false

func _ready():
	if not VERBOSE:
		return
	var skeletons := Spring.find_children("*", "Skeleton3D")
	if skeletons.size() == 1:
		var skeleton = skeletons[0] as Skeleton3D
		print("skeleton info ", skeleton)
		for bone_idx in skeleton.get_bone_count():
			print("BONE ", bone_idx)
			print("  name:        ", skeleton.get_bone_name(bone_idx))
			print("  parent:      ", skeleton.get_bone_parent(bone_idx))
			print("  global_pose: ", skeleton.get_bone_global_pose(bone_idx))
			print("  pose:        ", skeleton.get_bone_pose(bone_idx))
			print("  rest:        ", skeleton.get_bone_rest(bone_idx))

	
func _process(delta: float):
	time += delta
	Spring.set_spring_factor((sin(sin(time) * 3) + 1) * 0.5)
