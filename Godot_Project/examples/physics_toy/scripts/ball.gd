extends RigidBody3D

@export var whoosh_sound: AudioStreamPlayer3D

signal did_acccel()

func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		apply_central_impulse(linear_velocity)
		did_acccel.emit()

