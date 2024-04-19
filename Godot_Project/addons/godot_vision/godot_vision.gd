@tool
extends EditorPlugin

const AUTOLOAD_NAME = "GodotVision"

func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/godot_vision/GodotVision_autoload.tscn")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
