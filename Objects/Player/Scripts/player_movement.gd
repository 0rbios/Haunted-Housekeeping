extends RigidBody3D

var speed = 110
var horizontal = 0
var long = 0
var toBeNormalized

var direction

var dashing = false

var velocity = Vector3(0, 0, 0)

var carryingNode

func _physics_process(_delta):
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
			dashing = true
			if carryingNode != null:
				carryingNode.position = self.position
				carryingNode.carried = false
				carryingNode = null
			$"Dash Timer".start()
	
	if carryingNode != null:
		carryingNode.position = Vector3(self.position.x, self.position.y + 1, self.position.z)
	
	var tween = get_tree().create_tween()
	# Normal Cam
	tween.tween_property($Camera, "global_position", Vector3(self.global_position.x, $Camera.global_position.y, self.global_position.z + 5), 0.3)
	
	# Overview Cam
	#tween.tween_property($Camera, "global_position", Vector3(self.global_position.x, self.global_position.y + 50, self.global_position.z + 50), 0.3)

	toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * speed, 0, toBeNormalized.y * speed)
	apply_force(velocity)

func _dash_complete():
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
