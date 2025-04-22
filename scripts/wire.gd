extends Line2D

var source: Node = null
var target: Node = null
var wire_type: String = "data" # refactor to enum or similar structure

func _ready():
	width = 2
	if wire_type == "power":
		default_color = Color.RED
	elif wire_type == "data":
		default_color = Color.GREEN

func update_position():
	if source and target:
		points = [source.global_position, target.global_position]
