class_name Editor

extends Node3D

@onready var DepthPlane: Node3D = $DepthPlane

var selection: Node3D
var t: SceneTreeTimer

func move_selection(move_vector: Vector3):
	if not selection:
		printerr("No selection")
		return
	
	selection.position += move_vector
	


func _on_depth_plane_timer():
	DepthPlane.hide()

func _on_hud_on_depth(zero_to_one):
	DepthPlane.show()
	if not DepthPlane:
		printerr("Expected child named 'DepthPlane'")
	else:
		if t: t.timeout.disconnect(_on_depth_plane_timer)
		t = get_tree().create_timer(0.8)
		t.timeout.connect(_on_depth_plane_timer)

		const DEPTH_RANGE = 3.0
		DepthPlane.position.z = -zero_to_one * DEPTH_RANGE + DEPTH_RANGE / 2.0
		# print(zero_to_one, " -> ", DepthPlane.position.z)
		
