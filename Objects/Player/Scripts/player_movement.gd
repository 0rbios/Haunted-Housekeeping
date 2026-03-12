extends RigidBody3D

# Variables --------------------

# Movement
var baseSpeed = 110
var activeSpeed = 110
var horizontal = 0
var long = 0
var dashing = false
var velocity = Vector3(0, 0, 0)

# Carrying
var carryingNode = null
var hoverOver = null

# Functions --------------------

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _physics_process(_delta):
	if !is_multiplayer_authority(): return
	
	if carryingNode != null:
		if Input.is_action_pressed("Use"):
			carryingNode.position.z = -1
			carryingNode.position.y = 0
			activeSpeed = baseSpeed / 2.0
		else:
			carryingNode.position.z = 0
			carryingNode.position.y = 1
			activeSpeed = baseSpeed
	
	if dashing == false:
		if Input.is_action_just_pressed("Left"):
			horizontal = -1
		elif horizontal == -1 and !Input.is_action_pressed("Left"): 
			if Input.is_action_pressed("Right"):
				horizontal = 1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("Right"):
			horizontal = 1
		elif horizontal == 1 and !Input.is_action_pressed("Right"): 
			if Input.is_action_pressed("Left"):
				horizontal = -1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("Down"):
			long = 1
		elif long == 1 and !Input.is_action_pressed("Down"): 
			if Input.is_action_pressed("Up"):
				long = -1
			else:
				long = 0
		
		if Input.is_action_just_pressed("Up"):
			long = -1
		elif long == -1 and !Input.is_action_pressed("Up"): 
			if Input.is_action_pressed("Down"):
				long = 1
			else:
				long = 0
		
		if Input.is_action_just_pressed("Dash") and velocity != Vector3(0, 0, 0):
			activeSpeed = baseSpeed * 3
			self.set_collision_layer_value(4, true)
			dashing = true
			if carryingNode != null:
				drop()
			$"Dash Timer".start()
	
	if Input.is_action_just_pressed("Interact"):
		if carryingNode == null and hoverOver != null:
			pickup()
		elif carryingNode != null:
			drop()
	
	var toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * activeSpeed, 0, toBeNormalized.y * activeSpeed)
	apply_force(velocity)
	
	if velocity != Vector3(0, 0, 0):
		look_at(self.global_position + velocity)
	
func _dash_complete():
	self.set_collision_layer_value(4, false)
	activeSpeed = baseSpeed
	dashing = false

func pickup():
	carryingNode = hoverOver
	carryingNode.carriedBy = self

func drop():
	carryingNode.position = Vector3(0, 0, 0)
	carryingNode.pivot.position = self.position
	carryingNode.carriedBy = null
	carryingNode = null

func _touching_node(body):
	if body.is_in_group("object"):
		hoverOver = body

func _leave_node(body):
	if body.is_in_group("object"):
		hoverOver = null
