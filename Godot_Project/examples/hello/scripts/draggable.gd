extends Node

signal spatial_drag(Dictionary)

func _ready():
	spatial_drag.connect(on_spatial_drag)
	
func on_spatial_drag(params: Dictionary):
	# Move in 3D with the spatial gesture.
	self.global_transform = params['global_transform'] 
	
	# OR if you wanted to change just the position:
	# self.global_position = params['global_transform'].origin

func _exit_tree():
	spatial_drag.disconnect(on_spatial_drag)
