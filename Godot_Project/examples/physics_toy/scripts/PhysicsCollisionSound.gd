extends Node

@onready var parentRigidBody: RigidBody3D = get_parent()
@onready var sound: AudioStreamPlayer3D = $sound

# Called when the node enters the scene tree for the first time.
func _ready():
	if not parentRigidBody:
		printerr("Place 'PhysicsCollisionSound' as child of a RigidBody3D.")
		return
	if not sound:
		printerr("Expecting an AudioStreamPlayer3D as a child named 'sound'")
		return


func _on_ball_rigid_body_3d_body_entered(body: PhysicsBody3D):
	# print("enter ", body)
	sound.unit_size = parentRigidBody.linear_velocity.length()
	sound.play()
	
