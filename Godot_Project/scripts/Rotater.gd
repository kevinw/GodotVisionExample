extends Node3D

@export var axis: Vector3 = Vector3.UP
@export var speed: float = 1
var origPos: Vector3 = Vector3.ZERO
var t: float = 0

func _ready():
	origPos = position	

func _process(delta):
	t += delta * speed
	rotation.x = sin(t * 4.2) * 0.18
	position.y = origPos.y + sin(t + get_instance_id()) + 0.5
