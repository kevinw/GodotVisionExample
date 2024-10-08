extends Node

signal spatial_rotate3D(Dictionary)

func _ready():
	spatial_rotate3D.connect(on_spatial_rotate3D)
	
func on_spatial_rotate3D(params: Dictionary):
	self.global_transform = params['global_transform'] 
	
func _exit_tree():
	spatial_rotate3D.disconnect(on_spatial_rotate3D)
