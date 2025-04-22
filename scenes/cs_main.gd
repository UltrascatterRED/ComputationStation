extends Node2D
func _process(_delta):
	for comp in get_tree().get_nodes_in_group("components"):
		comp.evaluate_state()
