extends RigidBody3D

@onready var anim_player = $character_meshes/AnimationPlayer as AnimationPlayer

@onready var initial_global_position: Vector3 = self.global_position

func _ready():
	anim_player.play("walk")

func _process(_delta: float):
	# respawn the character if it gets knocked off screen
	if global_position.length() > 40:
		global_position = initial_global_position + Vector3(0, 7, 0)
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
