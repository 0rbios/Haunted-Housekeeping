extends RigidBody3D

# Variables --------------------

# Unique ID
@export var pickupType: String

# Carrying
var possibleCarrier = null
var carriedBy = null

# Functions --------------------

func _physics_process(_delta):
	self.freeze = linear_velocity.y == 0
	
	if Input.is_action_just_pressed("Interact"):
		if carriedBy == null and possibleCarrier != null:
			carriedBy = possibleCarrier
			self.position = Vector3(0,0,0)
			carriedBy.carryingNode = self
			reparent(carriedBy, false)
			self.rotation = Vector3(0, 0, 0)
		elif carriedBy != null:
			drop()
	
func _collision_enter(body: Node3D):
	if body.is_in_group("player") and !body.playerHovering:
		body.playerHovering = true
		possibleCarrier = body

func _collision_exit(body: Node3D):
	if body.is_in_group("player"):
		body.playerHovering = false
		possibleCarrier = null

func drop():
	self.position = carriedBy.position
	carriedBy.carryingNode = null
	carriedBy = null
	reparent(get_tree().root, false)
