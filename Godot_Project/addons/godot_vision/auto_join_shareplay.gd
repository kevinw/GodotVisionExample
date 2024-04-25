extends Node3D
class_name AutoJoinSharePlay

@export var auto_join = true
@export var auto_share_input = true

func _ready():
	if auto_join:
		await get_tree().create_timer(0.5).timeout
		call_deferred("join")

func join():
	var share_play := GodotVision.share_play
	if not share_play:
		return
	
	share_play.automatically_share_input = auto_share_input
	share_play.auto_join_activity()
	
