extends ComponentBase3D

func _ready():
	component_type = "vrm"
	required_inputs = []
	allowed_outputs = ["power"]
	
	var power_out_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	power_out_0.type = "out"
	power_out_0.parent_component = self
	power_out_0.wire_type = "power"
	power_out_0.update_material()
	
	sockets = {
		"power_out_0":power_out_0
	}
	socket_anchors = {
		"power_out_0":Vector3(.5, 0, 0)
	}
	
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two
	place_sockets()
	
	# debug
	var cpu = get_node("../CPU")
	if cpu:
		connect_output_wire(self.sockets["power_out_0"], cpu.sockets["power_in_0"], "power")

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
