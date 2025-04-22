extends ComponentBase3D

func _ready():
	component_type = "vrm"
	required_inputs = []
	allowed_outputs = ["power"]
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two

	var cpu = get_node("../CPU")
	if cpu:
		connect_wire(cpu, "power")
		print("CPU connected!")

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
