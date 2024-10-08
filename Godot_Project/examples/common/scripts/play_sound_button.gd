extends StaticBody3D

# Note! We use a special subclass of AudioStreamPlayer3D and its ".play_rk()"
# method instead of ".play()" so that RealityKit can know to play the audio.
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

func set_override_color(color):
	var mesh := $MeshInstance3D as MeshInstance3D
	var material: Material = null
	if color != null:
		material = StandardMaterial3D.new()
		material.albedo_color = color
	mesh.set_surface_override_material(0, material)

func clear_override_color():
	var mesh := $MeshInstance3D as MeshInstance3D
	mesh.set_surface_override_material(0, null)

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			audio_stream_player.play() # see note above
			set_override_color(Color.DARK_RED)
		else:
			clear_override_color()
		
