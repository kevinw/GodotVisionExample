class_name RKAudioStreamPlayer3D
extends AudioStreamPlayer3D

signal on_play(node: AudioStreamPlayer3D)

func play_rk(from_position: float = 0.0):
	on_play.emit(self)
	super.play(from_position)
