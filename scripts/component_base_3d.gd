extends Node3D
class_name ComponentBase3D
# Every component must have these defined

var component_type = "" # e.g., "cpu", "ram", "vrm"

# these two likely deprecated
var required_inputs = [] # e.g., ["power", "clock"]
var allowed_outputs = [] # e.g., ["data", "control"]

# Sockets are defined locations on this component that accept a single,
# specific input or output wire.
# KEY: expected wire type + in/out + index (i.e. "power_out_0", "power_out_1", "data_in_0")
# VALUE: socket node
# DEV NOTE: Devise way to store socket locations. Should be relative offset
#           vectors from center of parent component.
var sockets : Dictionary = {}
# Positions of sockets (relative to parent). 
# KEY: Same as Sockets key
# VALUE: Vector3 relative position.
var socket_anchors : Dictionary[String, Vector3] = {}
var connected_inputs = {}
var connected_outputs = {}

var state = "idle" # idle, active, powered, error

var previous_pos = Vector3()

func _ready():
	add_to_group("components")
	set_notify_transform(true)

# connects an output wire to a corresponding input socket
# self.out_socket --[outputs power/data to]--> other_component.in_socket
func connect_output_wire(from_socket: Socket3D, to_socket: Socket3D, wire_type: String):
	# debug
	#var from_sock_matches_wire: bool = wire_type == from_socket.wire_type
	#var to_sock_matches_wire: bool = wire_type == to_socket.wire_type
	#var from_sock_belongs_to_self: bool = sockets.values().has(from_socket)
	#var from_sock_is_out: bool = from_socket.type == "out"
	#var to_sock_is_in: bool = to_socket.type == "in"
	#print(from_sock_matches_wire)
	#print(to_sock_matches_wire)
	#print(from_sock_belongs_to_self)
	#print(from_sock_is_out)
	#print(to_sock_is_in)
	# end debug

	# execute only if:
	# * both sockets accept the passed wire type
	# * from_socket is a child of this instance
	# * from_socket is of type "out" (outputs power/data)
	# * to_socket is of type "in" (accepts power/data)
	if (wire_type == from_socket.wire_type and 
	wire_type == to_socket.wire_type and 
	sockets.values().has(from_socket) and 
	from_socket.type == "out" and 
	to_socket.type == "in"):
		var tree = get_tree()
		var wire = preload("res://scenes/components3D/Wire3D.tscn").instantiate()
		
		wire.source = from_socket
		wire.target = to_socket
		wire.wire_type = wire_type
		wire.add_to_group("wires")
		# rename wire to something unique and organized
		wire.name = "Wire3d_" + str(tree.get_node_count_in_group("wires"))
		tree.root.get_child(0).add_child(wire)
		# set wire scene global position to from_socket position to facilitate
		# correct wire placement
		wire.global_position = from_socket.global_position
		wire.update_material()
		wire.update_position()
		# debug
		print(str(self.name) + " connected to " + str(to_socket.parent_component))
	else:
		print(str(self.name) + ": Incompatible Connection!")
		print("From socket: " + str(from_socket.wire_type) + " " + str(from_socket.type))
		print("To socket: " + str(to_socket.wire_type) + " " + str(to_socket.type))
		print("Input wire type: " + str(wire_type))

# add all sockets in this component's sockets dictionary to the scene tree
# and position them according to their anchors
func place_sockets():
	for key in sockets:
		var socket = sockets[key]
		socket.name = key
		self.add_child(socket)
		socket.position = socket_anchors[key]

# DEV NOTE: As of 4/24 16:03, none of the below functions are used. Refactor
# or remove them.

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
