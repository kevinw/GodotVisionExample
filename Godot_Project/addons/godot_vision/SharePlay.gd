extends Node
class_name SharePlay

# called by GodotVision
signal peer_connected(peer_id: String, player_info: Dictionary)
signal peer_disconnected(peer_id)
signal message_received(from_peer: String, message: Dictionary)

# emitted by us to GodotVision
signal join_activity()

var automatically_share_input: bool = false


func broadcast_message(message: Dictionary):
	pass

func auto_join_activity():
	join_activity.emit()
