extends Node


signal drag
signal drag_ended

func _ready():
	drag.connect(func(params: Dictionary):
		self.global_position = params['location']
	)
	drag_ended.connect(func():
		print("drag ended")
	)
