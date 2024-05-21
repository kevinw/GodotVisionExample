extends Node3D

var planes_by_id: Dictionary = {}

func add_plane(id: String, vertices: Array, faces: Array, position: Vector3, quat: Quaternion):
	var triangles = PackedVector3Array()
	for i in faces:
		triangles.append(vertices[i])
	var mesh = create_mesh_from_vertices(triangles)
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = id
	var body = StaticBody3D.new()
	body.collision_layer = [4]
	body.input_ray_pickable = false
	body.collision_mask = [1,3]
	var shape = CollisionShape3D.new()
	shape.shape = mesh.create_convex_shape()
	body.add_child(shape)
	mesh_instance.add_child(body)
	add_child(mesh_instance)
	mesh_instance.basis = Basis(quat)
	mesh_instance.global_position = position
	return mesh_instance

func add_or_update_plane(id: String, vertices: Array, faces: Array, position: Vector3, quat: Quaternion):
	if planes_by_id.has(id):
		var plane = planes_by_id[id]
		if plane is MeshInstance3D:
			plane.name = "will_be_deleted"
			planes_by_id[id] = add_plane(id, vertices, faces, position, quat)
			remove_child(plane)
	else:
		var new_plane = add_plane(id, vertices, faces, position, quat)
		planes_by_id[id] = new_plane

func remove_plane(id: String):
	if planes_by_id.has(id):
		var plane_to_remove = planes_by_id[id] as Node
		remove_child(plane_to_remove)

func create_mesh_from_vertices(vertices: PackedVector3Array) -> Mesh:
	var mesh = ArrayMesh.new()
	var mesh_data = []
	mesh_data.resize(ArrayMesh.ARRAY_MAX)
	mesh_data[ArrayMesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	return mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
