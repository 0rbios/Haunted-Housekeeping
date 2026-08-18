extends CharacterBody3D

# Handle the player's movement around the scene

@onready var groundCheck : Node = $"Ground Check"

var canMove : bool = true

var speed = 4

var xVel = 0
var xKeys = []

var zVel = 0
var zKeys = []

var gravity = -3

func _physics_process(_delta: float) -> void:
	canMove = groundCheck.is_colliding()
	
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
	
	var velNorm = Vector2(xVel * int(canMove), zVel * int(canMove)).normalized()
	velocity = Vector3((velNorm.x * speed), gravity * int(!canMove), (velNorm.y * speed))
	
	if (xKeys + zKeys).size() > 0:
		rotation.y = atan2(velocity.x * -1, velocity.z * -1)
	move_and_slide()
