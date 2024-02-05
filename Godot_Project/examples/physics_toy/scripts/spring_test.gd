extends Node3D

@onready var Spring: Node3D = $Spring

var time: float = 0
	
func _process(delta: float):
	time += delta
	var sin01 := (sin(time * 3) + 1) * 0.5
	Spring.set_spring_factor(sin01)

