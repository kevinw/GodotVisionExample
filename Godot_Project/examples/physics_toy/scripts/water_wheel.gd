extends Node3D

@onready var rb = $RigidBody3D
@onready var hinge: HingeJoint3D = $HingeJoint3D
@onready var axis_mesh: MeshInstance3D = $RigidBody3D/AxisMesh

var orig_angular_damp: Vector2 = Vector2.ZERO
var target_damp: Vector2 = Vector2.ZERO

var SPEED_TO_CHANGE_ANGULAR_DAMP = 6.0

func _ready():
	orig_angular_damp = Vector2(rb.angular_damp, 0)
	
func _process(delta):
	var current := Vector2(rb.angular_damp, 0)
	if current != target_damp:
		rb.angular_damp = current.lerp(target_damp, delta * SPEED_TO_CHANGE_ANGULAR_DAMP).x
		if abs(rb.angular_damp - target_damp.x) < 0.001:
			rb.angular_damp = target_damp.x
	
func _on_rigid_body_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			target_damp = Vector2(40.0, 0)
		else:
			target_damp = orig_angular_damp

