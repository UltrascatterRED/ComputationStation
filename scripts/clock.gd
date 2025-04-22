extends ComponentBase

var elapsed_ms : int
func _ready():
	component_type = "clock"
	required_inputs = ["power"]
	allowed_outputs = ["data"]
	elapsed_ms = 0
	
	await get_tree().create_timer(0.2).timeout  # Wait a frame or two

	var cpu = get_node("/root/CsMain/CPU")
	if cpu:
		connect_wire(cpu, "data")

func _process(_delta):
	elapsed_ms = Time.get_ticks_msec()
	update_time()

# update display of clock
func update_time():
	var minutes = elapsed_ms / 60000
	var seconds = (elapsed_ms % 60000) / 1000
	var time_format = "%02d:%02d"
	$TimeDisplay.text = time_format % [minutes, seconds]
