extends Node3D

@export var dirtState = []

# Get A List Of All Dirt On The Map But Only On The Server
func _ready():
	if is_multiplayer_authority():
		dirtState = get_tree().get_nodes_in_group("dirt")
