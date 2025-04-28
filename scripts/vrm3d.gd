extends ComponentBase3D

func _init():
	var power_out_0 = preload("res://scenes/components3D/Socket3D.tscn").instantiate()
	power_out_0.type = Socket3D.io_flow.OUT
	power_out_0.parent_component = self
	power_out_0.wire_type = io_type.POWER
	power_out_0.update_material()
	
	sockets = {
		"power_out_0":power_out_0
	}
	socket_anchors = {
		"power_out_0":Vector3(.5, 0, 0)
	}

func _ready():
	place_sockets()
	
