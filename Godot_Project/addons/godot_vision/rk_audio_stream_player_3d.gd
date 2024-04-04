class_name RKAudioStreamPlayer3D
extends AudioStreamPlayer3D

signal on_play(node: AudioStreamPlayer3D)
signal on_prepare(node: AudioStreamPlayer3D)

@export var auto_prepare_resource: bool = true

func _enter_tree():
	if auto_prepare_resource:
		on_prepare.emit(self)

func play_rk(from_position: float = 0.0):
	on_play.emit(self)
	super.play(from_position)
