extends ComponentBase3D
class_name Ram3D

func _init():
	# initialize and assign socket nodes
	var data_in_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	# set socket type and wire type
	data_in_0.type = Socket3D.io_flow.IN
	data_in_0.parent_component = self
	data_in_0.wire_type = io_type.DATA
	data_in_0.update_material()
	
	sockets = {
		"data_in_0":data_in_0
	}
	socket_anchors = {
		"data_in_0":Vector3(.5, 0, -.8)
	}

func _ready():
	place_sockets()
