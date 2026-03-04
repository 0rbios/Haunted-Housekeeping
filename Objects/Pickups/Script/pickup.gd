extends RigidBody3D

# Variables --------------------

# Unique ID
@export var pickupType: String

# Carrying
var possibleCarrier = null
var carried = false

# Functions --------------------

func _physics_process(_delta):
	self.freeze = linear_velocity == Vector3(0, 0, 0)
	$Hitbox.disabled = linear_velocity == Vector3(0, 0, 0)

	if Input.is_action_just_pressed("Interact") and possibleCarrier != null:
		if carried == false:
			possibleCarrier.carryingNode = self
			carried = true
		else:
			self.position = possibleCarrier.position
			possibleCarrier.carryingNode = null
			carried = false

func _collision_enter(body: Node3D):
	if body.is_in_group("player") and !global.playerHovering:
		global.playerHovering = true
		possibleCarrier = body

func _collision_exit(body: Node3D):
	if body.is_in_group("player"):
		global.playerHovering = false
		possibleCarrier = null
