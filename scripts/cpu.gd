extends ComponentBase

func _ready():
	component_type = "cpu"
	required_inputs = ["power", "clock"]
	allowed_outputs = ["data", "control"]
	
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two

	var ram = get_node("/root/CsMain/RAM")
	if ram:
		connect_wire(ram, "data")
		#print("Ram connected!")

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
