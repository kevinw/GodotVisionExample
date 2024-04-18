extends Node3D

@onready var cam_node: Node3D = $VisionVolumeCamera
	
const pos_changes := [Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0)]

func _ready():
	var rot: Vector3 = Vector3(0, 0, 0)
	var pos: Vector3 = Vector3(0, 0, 0)
	var pos_change_index := 0
	
	await timeout(1)
	while true:
		await tween_prop(cam_node, "scale", Vector3(1, 1, 1) * 0.3, 0.5)
		await timeout(0.6)
		await tween_prop(cam_node, "scale", Vector3(1, 1, 1) * 1.0, 0.5)
		await timeout(0.6)
		
		rot += Vector3(0, 0.5 * PI, 0)
		pos += pos_changes[pos_change_index] * 4
		pos_change_index = (pos_change_index + 1) % pos_changes.size()
		
		await tween_prop(cam_node, "rotation", rot, 0.53)
		await timeout(0.53)
		await tween_prop(cam_node, "position", pos, 0.53)
		await timeout(0.53)

func timeout(amt: float):
	await get_tree().create_timer(amt).timeout

func tween_prop(node: Node3D, prop_name: String, value, duration: float):
	await create_tween().\
		tween_property(node, prop_name, value, duration)\
		.set_ease(Tween.EASE_IN_OUT)\
		.set_trans(Tween.TRANS_CUBIC)\
		.finished
