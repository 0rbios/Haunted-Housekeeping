extends Area3D

# Variables --------------------

@export var dirtType: String

# Functions ------------------

func _collision_detected(body: Node3D):
	if body.is_in_group("object") and Input.is_action_pressed("Use"):
		if dirtType == "ground":
			if body.pickupType == "mop":
				queue_free()
