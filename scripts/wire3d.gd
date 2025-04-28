extends Node3D
class_name Wire3D

const io_type = preload("res://scripts/io_type.gd")

var source: Socket3D = null
var target: Socket3D = null
var wire_type: int # refactor to enum or similar structure

# load wire path into script for use at runtime 
# (i.e. for placement preview rendering)
@onready var wire_path: Path3D = get_node("./Path3D")

# set wire material based on type
func update_material():
	var wire_mesh: CSGPolygon3D = get_node("./Path3D/WireMesh")
	# load material options
	var power_mat = preload("res://materials/wire_power_MAT.tres")
	var data_mat = preload("res://materials/wire_data_MAT.tres")
	
	if wire_type == io_type.POWER:
		wire_mesh.material = power_mat
	elif wire_type == io_type.DATA:
		wire_mesh.material = data_mat

func update_position():
	if source and target:
		# add points to path, wire mesh will automatically follow
		# NOTE: Specified point positions are RELATIVE to the curve3D position,
		# NOT global positions
		wire_path.curve.clear_points() # prevent residual points from old position(s)
		wire_path.curve.add_point(Vector3(0,0,0))
		#print(str(self.name) + " target loc: " + str(target.global_position)) # debug
		var target_relative_pos = target.global_position - self.global_position
		wire_path.curve.add_point(target_relative_pos)
