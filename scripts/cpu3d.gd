extends ComponentBase3D
class_name Cpu3D

# define enums for allowed inputs, outputs, etc here-ish

func _ready():
	required_inputs = ["power", "clock"]
	allowed_outputs = ["data"]
	# initialize and assign socket nodes
	var power_in_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	var data_out_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	# set socket types and wire types
	# DEV NOTE: consider refactoring to use constructor (i.e. func _init())
	power_in_0.type = "in"
	power_in_0.parent_component = self
	power_in_0.wire_type = "power"
	power_in_0.update_material()
	
	data_out_0.type = "out"
	data_out_0.parent_component = self
	data_out_0.wire_type = "data"
	data_out_0.update_material()
	
	sockets = { 
		"power_in_0": power_in_0, 
		"data_out_0": data_out_0 
	}
	socket_anchors = {
		"power_in_0": Vector3(-.3, 0, .45), 
		"data_out_0": Vector3(.45, 0, .3) 
	}
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two
	place_sockets()
	
	# debug
	var ram = get_node("../RAM")
	if ram:
		connect_output_wire(self.sockets["data_out_0"], ram.sockets["data_in_0"], "data")

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
