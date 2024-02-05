extends Node


signal drag(current_position: Vector3, start_position: Vector3)
signal drag_ended

func _ready():
	drag.connect(func(current_position: Vector3, _start_position: Vector3):
		self.global_position = current_position
	)
	drag_ended.connect(func():
		print("drag ended")
	)
