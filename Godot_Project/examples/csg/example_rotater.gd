extends Node3D
class_name ExampleRotater

@export var amount: Vector3 = Vector3(0.5, 1.6, 0.3)
@export var target: Node3D

func _enter_tree():
	if target == null:
		target = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	target.rotation += amount * delta
