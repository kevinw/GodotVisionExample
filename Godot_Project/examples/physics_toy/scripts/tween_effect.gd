extends MeshInstance3D

@export var property = "scale"
@export var amount: float = 2.0
@export var duration: float = 0.2

func trigger(_node: Node3D):
	var orig_value := scale
	var final_value := orig_value * amount
	
	var t := create_tween()
	t.tween_property(self, property, final_value, duration * 0.5)
	t.tween_property(self, property, orig_value, duration * 0.5)
	
