extends Area3D

# Variables --------------------

@export var cleanedBy: Array
@onready var dirtManager = $".."

# Functions ------------------

func _process(_delta):
	# Deletes Any Already Cleaned Dirt On Load
	if !dirtManager.dirtState.has(self):
		self.queue_free()

func _collision_detected(body: Node3D):
	if body.is_in_group("object") and Input.is_action_pressed("Use"):
		if cleanedBy.has(body.pickupType):
			_clean_dirt.rpc()

@rpc("any_peer", "call_local")
func _clean_dirt():
	if is_multiplayer_authority():
		dirtManager.dirtState.erase(self)
		queue_free()
