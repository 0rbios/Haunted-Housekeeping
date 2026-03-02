extends RigidBody3D

@export var pickupType: String

var canPickup = false
var isCarried = false

var possibleCarrier
@onready var carrier = $"../Player"

@onready var ghosts = get_tree().get_nodes_in_group("ghost")

func _physics_process(_delta):
	if linear_velocity == Vector3(0, 0, 0):
		self.freeze = true
		$Hitbox.disabled = true
	else:
		self.freeze = false
		$Hitbox.disabled = false
	
	if Input.is_action_just_pressed("Interact"):
		if canPickup:
			isCarried = true
			carrier = possibleCarrier 
		elif isCarried:
			isCarried = false
			canPickup = true
			self.position = Vector3(carrier.position.x, carrier.position.y, carrier.position.z)
	
	if carrier.dashing and isCarried:
		isCarried = false
		canPickup = true
		self.position = Vector3(carrier.position.x, carrier.position.y, carrier.position.z)
	
	if isCarried:
		canPickup = false
		self.position = Vector3(carrier.position.x, carrier.position.y + 1, carrier.position.z)
	
	if Input.is_action_pressed("Use") and isCarried:
		match pickupType:
			"mop": print("Item Used")

func _collision_enter(body: Node3D):
	if body.is_in_group("player") and global.playerHovering == false:
		global.playerHovering = true
		canPickup = true
		possibleCarrier = body
	if body.is_in_group("ghost"):
		canPickup = true
		possibleCarrier = body

func _collision_exit(body: Node3D):
	global.playerHovering = false
	if body.is_in_group("player"):
		canPickup = false
	if body.is_in_group("ghost"):
		canPickup = false
