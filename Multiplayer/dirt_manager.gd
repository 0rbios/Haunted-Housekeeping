extends Node3D

@export var dirtState = []

func _ready():
	if is_multiplayer_authority():
		dirtState = get_tree().get_nodes_in_group("dirt")
