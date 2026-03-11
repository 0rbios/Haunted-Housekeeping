extends RigidBody3D

# Variables --------------------

# Unique ID
@export var pickupType: String

# Carrying
@export var possibleCarrier = null
@export var carriedBy = null
@onready var pivot = $".."

# Functions --------------------

func _physics_process(_delta):
	if !is_multiplayer_authority(): return
	
	self.freeze = linear_velocity.y == 0
	
	if carriedBy != null:
		pivot.position = carriedBy.position
		pivot.rotation = carriedBy.rotation
	
	if Input.is_action_just_pressed("Interact"):
		if carriedBy == null and possibleCarrier != null:
			pickup()
		elif carriedBy != null:
			drop()

func _collision_enter(body: Node3D):
	if is_multiplayer_authority():
		if (body.is_in_group("player") or body.is_in_group("ghost")) and !body.playerHovering:
				body.playerHovering = true
				possibleCarrier = body

func _collision_exit(body: Node3D):
	if is_multiplayer_authority():
		if body.is_in_group("player") or body.is_in_group("ghost"):
			body.playerHovering = false
			possibleCarrier = null

func pickup():
	carriedBy = possibleCarrier
	carriedBy.carryingNode = self

func drop():
	self.position = carriedBy.position
	carriedBy.carryingNode = null
	carriedBy = null
