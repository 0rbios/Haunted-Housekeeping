extends CharacterBody3D

var speed = 10
var horizontal = 0
var long = 0
var toBeNormalized

var direction

var dashing = false

func _physics_process(_delta):
	if dashing == false:
		if Input.is_action_just_pressed("ui_left"):
			horizontal = -1
		elif horizontal == -1 and Input.is_action_just_released("ui_left"): 
			if Input.is_action_pressed("ui_right"):
				horizontal = 1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("ui_right"):
			horizontal = 1
		elif horizontal == 1 and Input.is_action_just_released("ui_right"): 
			if Input.is_action_pressed("ui_left"):
				horizontal = -1
			else:
				horizontal = 0
		
		if Input.is_action_just_pressed("ui_down"):
			long = 1
		elif long == 1 and Input.is_action_just_released("ui_down"): 
			if Input.is_action_pressed("ui_down"):
				long = -1
			else:
				long = 0
		
		if Input.is_action_just_pressed("ui_up"):
			long = -1
		elif long == -1 and Input.is_action_just_released("ui_up"): 
			if Input.is_action_pressed("ui_up"):
				long = 1
			else:
				long = 0
		
		if Input.is_action_just_pressed("ui_accept") and velocity != Vector3(0, 0, 0):
			speed = 30
			dashing = true
			$"Dash Timer".start()
	
	var tween = get_tree().create_tween()
	tween.tween_property($Camera, "global_position", Vector3(self.global_position.x, $Camera.global_position.y, self.global_position.z + 5), 0.5)
	
	
	toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * speed, 0, toBeNormalized.y * speed)
	move_and_slide()

func _dash_complete():
	speed = 10
	if horizontal == -1 and !Input.is_action_pressed("ui_left"): 
		if Input.is_action_pressed("ui_right"):
			horizontal = 1
		else:
			horizontal = 0
		
	if horizontal == 1 and !Input.is_action_pressed("ui_right"): 
		if Input.is_action_pressed("ui_left"):
			horizontal = -1
		else:
			horizontal = 0
		
	if long == 1 and !Input.is_action_pressed("ui_down"): 
		if Input.is_action_pressed("ui_down"):
			long = -1
		else:
			long = 0
		
	if long == -1 and !Input.is_action_pressed("ui_up"): 
		if Input.is_action_pressed("ui_up"):
			long = 1
		else:
			long = 0
		
	if horizontal == 0:
		if Input.is_action_pressed("ui_left"):
			horizontal = -1
		if Input.is_action_pressed("ui_right"):
			horizontal = 1
			
	if long == 0:
		if Input.is_action_pressed("ui_up"):
			long = -1
		if Input.is_action_pressed("ui_down"):
			long = 1

	dashing = false
	
