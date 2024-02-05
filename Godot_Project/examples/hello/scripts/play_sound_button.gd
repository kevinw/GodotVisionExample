extends StaticBody3D

# Note! We use a special subclass of AudioStreamPlayer3D and its ".play_rk()"
# method instead of ".play()" so that RealityKit can know to play the audio.
@onready var audio_stream_player: RKAudioStreamPlayer3D = $RKAudioStreamPlayer3D

func _on_input_event(_camera, event, _position, _normal, _shape_idx):

	if event is InputEventMouseButton  and event.pressed:
		audio_stream_player.play_rk() # see note above
