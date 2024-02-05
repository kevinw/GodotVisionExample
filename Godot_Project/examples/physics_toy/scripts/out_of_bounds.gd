extends Node
## Removes its parent node when it goes out of bounds.

## When this script's parent node falls under this position, we queue_free it
@export var queueFreeUnderY: float = -10

func _ready():
	var parent := get_parent()
	while parent and parent.is_inside_tree():
		await get_tree().create_timer(0.5 + randf() * 0.5).timeout
		if parent.global_position.y < queueFreeUnderY:
			parent.queue_free()
			break
		
		
