extends Node3D

@onready var body = $StaticBody3D
@onready var sound: AudioStreamPlayer3D = $sound

func _on_static_body_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		
		var targetRotationDegZ: float = 0
		if body.rotation_degrees.z > 0:
			targetRotationDegZ = -45
		else:
			targetRotationDegZ = 45
		var targetRotationDegrees: Vector3 = Vector3(0, 0, targetRotationDegZ)
		# body.rotation_degrees = targetRotationDegrees
		
		var t = create_tween().tween_property(body, "rotation_degrees", targetRotationDegrees, 0.2)
		t.set_ease(Tween.EASE_OUT)
		t.set_trans(Tween.TRANS_SPRING)
		
		if sound: sound.play()
		

