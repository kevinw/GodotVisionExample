#
# Moves an object in a sine wave. Used in the example scenes.
#
class_name ExampleMover
extends Node

@export var scale: Vector3 = Vector3(1, 0, 0)
@export var frequency: float = 1
@export var target: Node3D

var time: float = 0
var orig_pos: Vector3 = Vector3.ZERO

func _enter_tree():
	if target == null:
		target = get_parent() as Node3D
	if !target:
		printerr("ExampleMover: no target")
		set_process(false)
	else:
		orig_pos = target.position

func _process(delta):
	var prevTime := time
	time += delta
	target.position = orig_pos + sin(time * frequency) * scale
