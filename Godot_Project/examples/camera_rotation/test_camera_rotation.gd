extends Node3D

@onready var cam_node: Node3D = $VisionVolumeCamera


func _ready():
	await get_tree().create_timer(1.0).timeout
	var rot: Vector3 = Vector3(0, 0, 0)
	var pos: Vector3 = Vector3(0, 0, 0)
	
	var pos_changes := [Vector3(0, 0, 1), Vector3(1, 0, 0), Vector3(0, 0, -1), Vector3(-1, 0, 0)]
	var pos_change_index := 0
	
	while true:
		rot += Vector3(0, 0.5 * PI, 0)
		
		pos += pos_changes[pos_change_index] * 4
		pos_change_index = (pos_change_index + 1) % pos_changes.size()
		
		await create_tween().tween_property(cam_node, "rotation", rot, 0.5).set_ease(Tween.EASE_IN_OUT).finished
		await get_tree().create_timer(0.5).timeout
		await create_tween().tween_property(cam_node, "position", pos, 0.5).set_ease(Tween.EASE_OUT_IN).finished
		await get_tree().create_timer(1.0).timeout
		
	


