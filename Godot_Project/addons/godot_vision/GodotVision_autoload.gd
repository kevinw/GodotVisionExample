extends Node
class_name GodotVision_autoload

@onready var share_play: SharePlay = $SharePlay
var scene_tree: SceneTree

func running_on_vision():
	return OS.get_name() == "iOS"

func _enter_tree():
	if !running_on_vision():
		scene_tree = get_tree()
		scene_tree.node_added.connect(_on_node_added)
	
func _exit_tree():
	if !running_on_vision():
		scene_tree.node_added.disconnect(_on_node_added)
		scene_tree = null
	
func _on_node_added(node: Node):
	if node.has_signal("spatial_drag"):		
		var col := node as CollisionObject3D
		if col:
			_simulate_godot_vision_drag_signal(node)
			col.input_capture_on_drag = true
		else:
			printerr("Node with signal 'spatial_drag' is not CollisionObject3D")

#
# On mac, we simulate the 'drag' signal that gets called from RealityKit
#
func _simulate_godot_vision_drag_signal(node: CollisionObject3D):
	var ctx = {
		"dragging": false,
		"camera": null,
		"orig_position": Vector2.ZERO,
		"orig_transform": node.global_transform,
		"orig_event_pos": Vector3.ZERO,
		"last_motion_event_position": Vector2.ZERO,
		"sent_began": false
	}
	
	ctx["emit_event"] = func(ended: bool):
		var current_event_pos := (ctx["camera"] as Camera3D).project_position(ctx["last_motion_event_position"] as Vector2, ctx["length"])
		var world_space_pos := (ctx["orig_node_position"] as Vector3) + (current_event_pos - (ctx["orig_event_pos"] as Vector3))
		var transform := ctx["orig_transform"] as Transform3D
		transform.origin = world_space_pos
		
		var phase := "began"
		if ended:
			phase = "ended"
		else:
			if ctx["sent_began"]:
				phase = "changed"
			else:
				ctx["sent_began"] = true
		
		var params := {
			"global_transform": transform,
			"phase": phase
		}

		node.emit_signal("spatial_drag", params)

	node.input_event.connect(func(camera: Camera3D, event, position: Vector3, normal, shape_idx):
		ctx["camera"] = camera
		var buttonEvent := event as InputEventMouseButton
		if buttonEvent:				
			if not ctx["dragging"] && buttonEvent.pressed:
				# start dragging
				ctx["dragging"] = true
				ctx["orig_node_position"] = node.global_position
				ctx["length"] = (camera.global_position - node.global_position).length() # No, use 'position' converted to global
				ctx["orig_event_pos"] = camera.project_position(buttonEvent.position, ctx["length"])
				ctx["last_motion_event_position"] = buttonEvent.position
				
			elif ctx["dragging"] and not buttonEvent.pressed:
				# stop dragging
				ctx["emit_event"].call(true)
				ctx["dragging"] = false
				ctx["orig_position"] = Vector3.ZERO
				ctx["camera"] = null
				ctx["sent_began"] = false

		var motionEvent := event as InputEventMouseMotion
		if motionEvent and motionEvent.button_mask & 1 and ctx["dragging"]:
			ctx["last_motion_event_position"] = motionEvent.position
			ctx["emit_event"].call(false)
	)
