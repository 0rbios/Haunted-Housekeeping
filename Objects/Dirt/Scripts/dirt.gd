extends Area3D

# Variables --------------------

@export var cleanedBy: Array

# Functions ------------------

func _collision_detected(body: Node3D):
	if body.is_in_group("object") and Input.is_action_pressed("Use"):
		if cleanedBy.has(body.pickupType):
			_clean_dirt.rpc()

@rpc("any_peer", "call_local")
func _clean_dirt():
	queue_free()
