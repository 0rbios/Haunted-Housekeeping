extends CharacterBody3D

# Handle the player's movement around the scene

var speed = 10

var xVel = 0
var xKeys = []

var zVel = 0
var zKeys = []

var gravity = -0.1

var vel = Vector3(0, 0, 0)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"): xKeys.append(-1)
	if Input.is_action_just_pressed("ui_right"): xKeys.append(1)
	if Input.is_action_just_pressed("ui_up"): zKeys.append(-1)
	if Input.is_action_just_pressed("ui_down"): zKeys.append(1)
	
	if Input.is_action_just_released("ui_left"): xKeys.erase(-1)
	if Input.is_action_just_released("ui_right"): xKeys.erase(1)
	if Input.is_action_just_released("ui_up"): zKeys.erase(-1)
	if Input.is_action_just_released("ui_down"): zKeys.erase(1)
	
	xVel = 0
	for key in xKeys.size():
		xVel += xKeys[key] * (key + 1)
	
	zVel = 0
	for key in zKeys.size():
		zVel += zKeys[key] * (key + 1)
	
	var velNorm = Vector2(xVel, zVel).normalized()
	vel = Vector3((velNorm.x * speed), gravity, (velNorm.y * speed))
	
	move_and_collide(vel)
