extends Node


signal drag(current_position: Vector3, start_position: Vector3, expected_end: Vector3)
signal drag_ended

func _ready():
	drag.connect(func(params: Dictionary):
		self.global_position = params['location']
	)
	drag_ended.connect(func():
		print("drag ended")
	)
