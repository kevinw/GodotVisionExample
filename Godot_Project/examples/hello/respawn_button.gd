class_name ClickableButton
extends AnimatableBody3D

signal on_clicked

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			on_clicked.emit()
			
