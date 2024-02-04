@tool
extends Area3D

func _ready():
	renamed.connect(func():
		if name != "VisionVolumeCamera":
			printerr("node must be named VisionVolumeCamera to be recognized by VisionOS.")
		else:
			print("VisionVolumeCamera name is correct.")
	)
	
	# don't do physics updates for this, since we're just using it for a cube reference
	monitorable = false
	monitoring = false

func _add_debug_corners():
	var shape = $CollisionShape3D as CollisionShape3D
	if not shape:
		printerr("Expected $CollisionShape3D to be a CollisionShape3D")
		return

	var boxShape = shape.shape as BoxShape3D
	if not boxShape:
		printerr("Expected $CollisionShape3D.shape to be a BoxShape3D")
		return
		
	var material = StandardMaterial3D.new()
	var mesh = SphereMesh.new()
	mesh.radius = 0.2
	mesh.height = mesh.radius * 2
	mesh.material = material
	
	material.albedo_color = Color(1, 1, 0, 1)
	print("size", boxShape.size)
	
	var debugInst = MeshInstance3D.new()
	debugInst.mesh = mesh
	debugInst.can_process()
	
	var add_at_pos = func(pos: Vector3):
		var node = debugInst.duplicate()
		add_child(node)
		node.position = pos
		
	var half = boxShape.size * 0.5
		
	add_at_pos.call(Vector3(half.x, half.y, -half.z))
	add_at_pos.call(Vector3(half.x, -half.y, -half.z))
	add_at_pos.call(Vector3(-half.x, half.y, -half.z))
	add_at_pos.call(Vector3(-half.x, -half.y, -half.z))
	
	add_at_pos.call(Vector3(half.x, half.y, half.z))
	add_at_pos.call(Vector3(half.x, -half.y, half.z))
	add_at_pos.call(Vector3(-half.x, half.y, half.z))
	add_at_pos.call(Vector3(-half.x, -half.y, half.z))
