extends Node3D

@export var emits: PackedScene

signal emitted_node(node: Node3D)

func _ready():
	while true:
		await get_tree().create_timer(randf_range(2.0, 5.0)).timeout
		var obj := emits.instantiate() as Node3D
		get_parent().add_child(obj)
		obj.global_position = global_position
		
		emitted_node.emit(obj)
