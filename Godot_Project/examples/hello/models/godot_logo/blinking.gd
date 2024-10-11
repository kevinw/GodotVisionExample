extends Node3D

func _ready() -> void:
	var eyes := find_child("Object_6") as Node3D
	if eyes:
		start_blinking(eyes)

func start_blinking(eyes: Node3D):
	while is_inside_tree():
		await get_tree().create_timer(0.8 + randf() * 3).timeout
		
		var tween := get_tree().create_tween()
		tween.tween_property(eyes, "scale", Vector3(1, 0.05, 1), 0.08)
		await tween.finished
		
		var tween2 := get_tree().create_tween()
		tween2.tween_property(eyes, "scale", Vector3(1, 1, 1), 0.1)
		await tween2.finished
			
