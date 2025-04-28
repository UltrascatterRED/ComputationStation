extends Node3D

func _ready():
	
	const io_type = preload("res://scripts/io_type.gd")
	
	var cpu = get_node("CPU")
	var ram = get_node("RAM")
	var vrm = get_node("VRM")
	
	if cpu and ram:
		cpu.connect_output_wire(cpu.sockets["data_out_0"], ram.sockets["data_in_0"], io_type.DATA)

	if cpu and vrm:
		vrm.connect_output_wire(vrm.sockets["power_out_0"], cpu.sockets["power_in_0"], io_type.POWER)
