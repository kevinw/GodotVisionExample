extends Node3D

@export var animation_name: String = ""

func _ready():
	var animation_players := find_children("*", "AnimationPlayer")
	if animation_players.size() == 0:	
		return

	var anim_player = animation_players[0] as AnimationPlayer
	if anim_player && animation_name && animation_name.length() > 0:
		var anim := anim_player.get_animation(animation_name)
		if anim:
			anim.loop_mode = Animation.LOOP_LINEAR
			anim_player.play(animation_name)
