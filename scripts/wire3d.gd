extends Node3D
class_name Wire3D

var source: Node = null
var target: Node = null
var wire_type: String = "data" # refactor to enum or similar structure

# get mesh and material data
@onready var wire_mesh: CSGPolygon3D = get_node("./Path3D/WireMesh")
@onready var wire_path: Path3D = get_node("./Path3D")

func _ready():
	# set wire color based on type
	if wire_type == "power":
		wire_mesh.material.albedo_color = Color.RED
	elif wire_type == "data":
		wire_mesh.material.albedo_color = Color.GREEN

func update_position():
	if source and target:
		# add points to path, wire mesh will automatically follow
		wire_path.curve.clear_points() # prevent residual points from old position(s)
		wire_path.curve.add_point(source.global_position)
		wire_path.curve.add_point(target.global_position)
