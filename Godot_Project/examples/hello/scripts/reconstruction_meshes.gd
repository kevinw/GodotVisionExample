extends Node3D

var meshes_by_id: Dictionary = {}
var shared_material = StandardMaterial3D.new()

func add_mesh(id: String, vertices: Array, faces: Array, position: Vector3, quat: Quaternion):
	var triangles = PackedVector3Array()
	for i in faces:
		triangles.append(vertices[i])
	var mesh = create_mesh_from_vertices(triangles)
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.name = id
	add_child(mesh_instance)
	mesh_instance.basis = Basis(quat)
	mesh_instance.global_position = position
	return mesh_instance

func add_or_update_reconstruction_mesh(id: String, vertices: Array, faces: Array, position: Vector3, quat: Quaternion):
	if meshes_by_id.has(id):
		var mesh_instance = meshes_by_id[id]
		if mesh_instance is MeshInstance3D:
			var triangles = PackedVector3Array()
			for i in faces:
				triangles.append(vertices[i])
			var mesh = create_mesh_from_vertices(triangles)
			mesh_instance.mesh = mesh
			mesh_instance.basis = Basis(quat)
			mesh_instance.global_position = position
	else:
		var new_mesh = add_mesh(id, vertices, faces, position, quat)
		meshes_by_id[id] = new_mesh

func remove_mesh(id: String):
	if meshes_by_id.has(id):
		var mesh_to_remove = meshes_by_id[id] as Node
		
		# sometimes this breaks? why
		
		#remove_child(mesh_to_remove)

func create_mesh_from_vertices(vertices: PackedVector3Array) -> Mesh:
	var mesh = ArrayMesh.new()
	var mesh_data = []
	mesh_data.resize(ArrayMesh.ARRAY_MAX)
	mesh_data[ArrayMesh.ARRAY_VERTEX] = vertices
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, mesh_data)
	mesh.surface_set_material(0, shared_material)
	return mesh

# Called when the node enters the scene tree for the first time.
func _ready():
	shared_material.albedo_color = Color(0.0, 0.5, 0.8, 0.5)
	shared_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
