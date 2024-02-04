extends RigidBody3D

@onready var anim_player = $character_meshes/AnimationPlayer

func _ready():
	anim_player.play("walk")
