extends Node

signal drag
signal drag_ended

func _ready():
	drag.connect(func(params: Dictionary):
		self.global_transform = params['global_transform']

		# if you wanted just the position:
		# self.global_transform = params['global_transform'].origin
	)

	drag_ended.connect(func():
		print("drag ended")
	)
