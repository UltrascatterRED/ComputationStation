extends ComponentBase3D
class_name Cpu3D

func _init():
	# initialize and assign socket nodes
	var power_in_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	var data_out_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	# set socket types and wire types
	# DEV NOTE: consider refactoring to use constructor (i.e. func _init())
	power_in_0.type = Socket3D.io_flow.IN
	power_in_0.parent_component = self
	power_in_0.wire_type = io_type.POWER
	power_in_0.update_material()
	
	data_out_0.type = Socket3D.io_flow.OUT
	data_out_0.parent_component = self
	data_out_0.wire_type = io_type.DATA
	data_out_0.update_material()
	
	sockets = { 
		"power_in_0": power_in_0, 
		"data_out_0": data_out_0 
	}
	socket_anchors = {
		"power_in_0": Vector3(-.3, 0, .45), 
		"data_out_0": Vector3(.45, 0, .3) 
	}

func _ready():
	place_sockets()
