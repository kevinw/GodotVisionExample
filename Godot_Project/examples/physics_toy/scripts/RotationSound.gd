extends Node

@onready var target: Node3D = get_parent()
@onready var sound: AudioStreamPlayer3D = $AudioStreamPlayer3D

var new_val: int = 0
var old_val: int = 0

func _process(delta):
	var new_val = int(target.rotation.z / (PI * 0.25))
	if new_val != old_val:
		sound.play()
	old_val = new_val
	
