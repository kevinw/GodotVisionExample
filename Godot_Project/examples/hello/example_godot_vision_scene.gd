extends Node

@onready var drag_container = $drag_container
@onready var draggable: Node3D = $"Drag Me Button"
var global_transform_start_origin = Vector3(0,0,0)
var draggable_start_position = Vector3(0,0,0)

func _ready():
	drag_container.spatial_drag.connect(on_spatial_drag)
	
func on_spatial_drag(params: Dictionary):
	if params["phase"] == "began":
		global_transform_start_origin = params["global_transform"].origin
		draggable_start_position = draggable.global_transform.origin
	var delta = params["global_transform"].origin - global_transform_start_origin
	var new_basis = params["global_transform"]
	new_basis.origin = draggable_start_position + delta
	draggable.global_transform = new_basis
