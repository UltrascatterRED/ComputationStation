extends ComponentBase

func _ready():
	component_type = "ram"
	required_inputs = ["power", "control", "data"]
	allowed_outputs = ["data"]

func generate_unique_id():
	return str(component_type) + "_" + str(randi())
