extends CharacterBody3D

var speed = 10
var horizontal = 0
var long = 0
var toBeNormalized

var oldPos = 0
var curPos = 0
var distanceTraveled
var movementSpeedCalc

func _ready():
	$"Speedometer Timer".start()

func _physics_process(_delta):	
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
	
	toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * speed, 0, toBeNormalized.y * speed)
	move_and_slide()

func _update_speedometer():
	curPos = sqrt(self.position.x ** 2 + self.position.z ** 2)
	
	distanceTraveled = curPos - oldPos
	
	movementSpeedCalc = abs(distanceTraveled) / $"Speedometer Timer".wait_time
	
	oldPos = curPos
	
	$"Speedometer Timer".start()
