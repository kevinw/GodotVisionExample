extends Node

signal spatial_magnify(Dictionary)

func _ready():
	spatial_magnify.connect(on_spatial_magnify)
	
func on_spatial_magnify(params: Dictionary):
	self.global_transform = params["global_transform"]

func _exit_tree():
	spatial_magnify.disconnect(on_spatial_magnify)
