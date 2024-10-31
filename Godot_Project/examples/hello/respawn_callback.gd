extends Node3D

func _on_respawn_button_on_clicked() -> void:
	print("reloading current scene...")
	get_tree().reload_current_scene()
