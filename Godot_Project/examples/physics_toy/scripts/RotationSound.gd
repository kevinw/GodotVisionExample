extends Node

@onready var target: Node3D = get_parent()
@onready var sound: RKAudioStreamPlayer3D = $RKAudioStreamPlayer3D

var new_val: int = 0
var old_val: int = 0


func _process(delta):
	var new_val = int(target.rotation.z / (PI * 0.25))
	if new_val != old_val:
		sound.play_rk()
	old_val = new_val
	
