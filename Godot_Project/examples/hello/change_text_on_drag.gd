extends MeshInstance3D

@onready var original_text: String = (mesh as TextMesh).text

func set_label(label_text: String):
	(mesh as TextMesh).text = label_text

func _on_drag_me_button_spatial_drag(evt: Dictionary):
	match evt.phase:
		"began":
			set_label("Wheee!!")
		"ended":
			set_label(original_text)
