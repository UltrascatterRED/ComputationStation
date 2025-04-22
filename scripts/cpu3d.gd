extends ComponentBase3D

func _ready():
	component_type = "cpu"
	required_inputs = ["power", "clock"]
	allowed_outputs = ["data", "control"]
	
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two

	var ram = get_node("../RAM")
	if ram:
		connect_wire(ram, "data")
		print("RAM connected!")

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
