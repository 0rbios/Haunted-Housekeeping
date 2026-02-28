extends RigidBody3D

var canPickup = false
var isCarried = false

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
		elif isCarried:
			isCarried = false
			canPickup = true
			self.position = Vector3($"../Player".position.x, $"../Player".position.y, $"../Player".position.z)
	
	if $"../Player".dashing and isCarried:
		isCarried = false
		canPickup = true
		self.position = Vector3($"../Player".position.x, $"../Player".position.y, $"../Player".position.z)
	
	if isCarried:
		canPickup = false
		self.position = Vector3($"../Player".position.x, $"../Player".position.y + 1, $"../Player".position.z)

func _collision_enter(body: Node3D):
	if body.is_in_group("player") and global.playerHovering == false:
		global.playerHovering = true
		canPickup = true

func _collision_exit(body: Node3D):
	global.playerHovering = false
	if body.is_in_group("player"):
		canPickup = false
