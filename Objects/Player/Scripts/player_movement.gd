extends RigidBody3D

# Variables --------------------

# Movement
var speed = 110
var horizontal = 0
var long = 0
var dashing = false
var velocity = Vector3(0, 0, 0)

# Carrying
var carryingNode

# Functions --------------------

func _physics_process(_delta):
	
	if carryingNode != null:
		if Input.is_action_pressed("Use"):
			carryingNode.position.z = -1
			carryingNode.position.y = 0
		else:
			carryingNode.position.z = 0
			carryingNode.position.y = 1
	
	if dashing == false:
		
		if Input.is_action_just_pressed("Left"):
			horizontal = -1
		elif horizontal == -1 and Input.is_action_just_released("Left"): 
			if Input.is_action_pressed("Right"):
				horizontal = 1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("Right"):
			horizontal = 1
		elif horizontal == 1 and Input.is_action_just_released("Right"): 
			if Input.is_action_pressed("Left"):
				horizontal = -1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("Down"):
			long = 1
		elif long == 1 and Input.is_action_just_released("Down"): 
			if Input.is_action_pressed("Up"):
				long = -1
			else:
				long = 0
		
		if Input.is_action_just_pressed("Up"):
			long = -1
		elif long == -1 and Input.is_action_just_released("Up"): 
			if Input.is_action_pressed("Down"):
				long = 1
			else:
				long = 0
		
		if Input.is_action_just_pressed("Dash") and velocity != Vector3(0, 0, 0):
			speed = 330
			self.set_collision_layer_value(4, true)
			dashing = true
			if carryingNode != null:
				carryingNode.drop()
				carryingNode = null
			$"Dash Timer".start()
	
	var toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * speed, 0, toBeNormalized.y * speed)
	apply_force(velocity)
	
	if velocity != Vector3(0, 0, 0):
		look_at(self.global_position + velocity)
	
func _dash_complete():
	self.set_collision_layer_value(4, false)
	
	speed = 110
	
	if horizontal == -1 and !Input.is_action_pressed("Left"): 
		if Input.is_action_pressed("Right"):
			horizontal = 1
		else:
			horizontal = 0
		
	if horizontal == 1 and !Input.is_action_pressed("Right"): 
		if Input.is_action_pressed("Left"):
			horizontal = -1
		else:
			horizontal = 0
		
	if long == 1 and !Input.is_action_pressed("Down"): 
		if Input.is_action_pressed("Up"):
			long = -1
		else:
			long = 0
		
	if long == -1 and !Input.is_action_pressed("Up"): 
		if Input.is_action_pressed("Down"):
			long = 1
		else:
			long = 0
		
	if horizontal == 0:
		if Input.is_action_pressed("Left"):
			horizontal = -1
		if Input.is_action_pressed("Right"):
			horizontal = 1
			
	if long == 0:
		if Input.is_action_pressed("Up"):
			long = -1
		if Input.is_action_pressed("Down"):
			long = 1
	
	dashing = false
