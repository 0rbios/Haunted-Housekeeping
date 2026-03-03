extends RigidBody3D

@export var pickupType: String

var possibleCarrier = null
var carried = false

func _physics_process(_delta):
	if linear_velocity == Vector3(0, 0, 0):
		self.freeze = true
		$Hitbox.disabled = true
	else:
		self.freeze = false
		$Hitbox.disabled = false

	if Input.is_action_just_pressed("Interact") and possibleCarrier != null:
		if carried == false:
			possibleCarrier.carryingNode = self
			carried = true
		else:
			self.position = possibleCarrier.position
			possibleCarrier.carryingNode = null
			carried = false
	
	if Input.is_action_pressed("Use") and carried == true:
		match pickupType:
			"mop": print("Item Used")

func _collision_enter(body: Node3D):
	if body.is_in_group("player") and global.playerHovering == false:
		global.playerHovering = true
		possibleCarrier = body

func _collision_exit(body: Node3D):
	global.playerHovering = false
	if body.is_in_group("player"):
		possibleCarrier = null
