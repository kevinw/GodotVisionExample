extends Node
class_name GodotVision_autoload

var scene_tree: SceneTree

func running_on_vision():
	return OS.get_name() == "iOS"

func _enter_tree():
	if !running_on_vision():
		scene_tree = get_tree()
		scene_tree.node_added.connect(on_node_added)
	
func _exit_tree():
	if !running_on_vision():
		scene_tree.node_added.disconnect(on_node_added)
		scene_tree = null
	
func on_node_added(node: Node):
	if node.has_signal("drag"):		
		var col := node as CollisionObject3D
		if col:
			_simulate_godot_vision_drag_signal(node)
			col.input_capture_on_drag = true
		else:
			printerr("Node with signal 'drag' is not CollisionObject3D")

#
# On mac, we simulate the 'drag' signal that gets called from RealityKit
#
func _simulate_godot_vision_drag_signal(node: CollisionObject3D):
	var ctx = {
		"dragging": false,
		"orig_position": Vector2.ZERO,
		"orig_transform": node.global_transform,
		"orig_event_pos": Vector3.ZERO
	}
	
	node.input_event.connect(func(camera: Camera3D, event, position: Vector3, normal, shape_idx):
		var buttonEvent := event as InputEventMouseButton
		if buttonEvent:				
			if not ctx["dragging"] && buttonEvent.pressed:
				# start dragging
				ctx["dragging"] = true
				ctx["orig_node_position"] = node.global_position
				ctx["length"] = (camera.global_position - node.global_position).length() # No, use 'position' converted to global
				ctx["orig_event_pos"] = camera.project_position(buttonEvent.position, ctx["length"])
				
			elif ctx["dragging"] and not buttonEvent.pressed:
				# stop dragging
				ctx["dragging"] = false
				ctx["orig_position"] = Vector3.ZERO
		
		var motionEvent := event as InputEventMouseMotion
		if motionEvent and motionEvent.button_mask & 1 and ctx["dragging"]:
			var current_event_pos := camera.project_position(motionEvent.position, ctx["length"])
			var world_space_pos := (ctx["orig_node_position"] as Vector3) + (current_event_pos - (ctx["orig_event_pos"] as Vector3))
			var transform := ctx["orig_transform"] as Transform3D
			transform.origin = world_space_pos
			node.emit_signal("drag", {
				"global_transform": transform
			})
	)
