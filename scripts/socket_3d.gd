extends Node3D
class_name Socket3D

# Parent component. All sockets must have one.
# DEV NOTE: Assign parent FROM parent script (i.e. during _ready())
# type determines the direction of data/powr flow accepted by this socket
var type: String # "in" or "out", short for input or output
var parent_component: ComponentBase3D
# wire type accepted by this instance
var wire_type
# Actual wire node (if present)
var wire : Node

func update_material():
	var mesh : MeshInstance3D = get_node("./SocketMesh")
	# load material options for sockets
	var power_mat = preload("res://materials/socket_power_MAT.tres")
	var data_mat = preload("res://materials/socket_data_MAT.tres")
	if self.wire_type == "power":
		mesh.set_surface_override_material(0, power_mat)
	elif self.wire_type == "data":
		mesh.set_surface_override_material(0, data_mat)
	else:
		print("Invalid or null wire type!")

# Assigns input wire to this socket. Does not affect wire's properties or
# position, as that is the responsibility of the Wire3D class
func seat_wire(w : Wire3D):
	# seat wire only if a wire isn't already seated and the type is compatible
	# with this socket
	if !wire and w.wire_type == self.wire_type:
		self.wire = w
	else:
		print("Wire seating failed")
