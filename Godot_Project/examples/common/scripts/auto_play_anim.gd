extends Node3D

@export var animation_name: String = ""

@export var setLoopModeEnabled := true
@export var setLoopMode        := Animation.LOOP_LINEAR

func _ready():
	var animation_players := find_children("*", "AnimationPlayer")
	if animation_players.size() == 0:
		printerr("no AnimationPlayer children found")	
		return

	var anim: Animation
	var anim_player = animation_players[0] as AnimationPlayer
	if not anim_player:
		return
		
	if anim_player && animation_name && animation_name.length() > 0:
		anim = anim_player.get_animation(animation_name)
		
	if not anim:
		var anim_keys := anim_player.get_animation_list()
		if anim_keys.size() > 0:
			animation_name = anim_keys[0]
	if animation_name:
		anim = anim_player.get_animation(animation_name)
		if setLoopModeEnabled:
			anim.loop_mode = setLoopMode
		print("animation_name ", animation_name)
		anim_player.play(animation_name)
		
		
