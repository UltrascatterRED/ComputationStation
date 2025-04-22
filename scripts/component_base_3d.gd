extends Node3D
class_name ComponentBase3D
# Every component must have these defined
var component_id = ""
var component_type = "" # e.g., "cpu", "ram", "vrm"
var required_inputs = [] # e.g., ["power", "clock"]
var allowed_outputs = [] # e.g., ["data", "control"]

var connected_inputs = {}
var connected_outputs = {}

var state = "idle" # idle, active, powered, error

var previous_pos = Vector3()

func _ready():
	component_id = generate_unique_id()
	add_to_group("components")
	set_notify_transform(true)

func generate_unique_id():
	return str(component_type) + "_" + str(randi())

# connects to_component to this component as an output
# self ----[outputs to]---> to_component
# DEV NOTE: Currently malfunctions in certain scenarios (i.e.
#  CPU and VRM are both present in scene, only one of two
#  requisite wires is drawn. Find cause.
#  Update: not name stomping bc all wires are instantiated. Seems
#  to be both wires possessing identical properties (same source,
#  dest, color, etc)
func connect_wire(to_component: Node, wire_type: String):
	if wire_type in allowed_outputs and wire_type in to_component.required_inputs:
		var tree = get_tree()
		var wire = preload("res://scenes/components3D/Wire3D.tscn").instantiate()
		wire.source = self
		wire.target = to_component
		wire.wire_type = wire_type
		wire.add_to_group("wires")
		# rename wire to something unique and organized
		wire.name = "Wire3d_" + str(tree.get_node_count_in_group("wires"))
		
		tree.root.get_child(0).add_child(wire)
		wire.update_position()

		connected_outputs[to_component.component_id] = wire
		to_component.connected_inputs[component_id] = wire
	else:
		print("Incompatible connection")

# _notification() and _process() are trying to solve the same issue of
# detecting when this component is moved in the scene. Neither work yet,
# but only use one.
func _notification(what):
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		for input in connected_inputs:
			if typeof(input) == typeof(Wire3D):
				input.update_position()
		for output in connected_outputs:
			if typeof(output) == typeof(Wire3D):
				output.update_position()

func _process(_delta):
	# refresh wire positions if this component was moved
	if global_position != previous_pos:
		for input in connected_inputs:
			if typeof(input) == typeof(Wire3D):
				input.update_position()
		for output in connected_outputs:
			if typeof(output) == typeof(Wire3D):
				output.update_position()
	previous_pos = global_position

func evaluate_state():
	# get types of all wires present in connected_inputs
	var received_types = connected_inputs.values().map(func(w): return w.wire_type)

	var has_all_required = true
	for req in required_inputs:
		if req not in received_types:
			has_all_required = false
			break

	if has_all_required:
		state = "active"
	else:
		state = "idle"
	update_visual_state()

func update_visual_state():
	# replace print() with color modulation of mesh material
	match state:
		"active":
			print("green!")
		"idle":
			print("gray!")
		"error":
			print("red!")
