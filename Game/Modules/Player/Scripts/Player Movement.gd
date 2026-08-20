extends CharacterBody3D

# Handle the player's movement around the scene

@onready var _groundCheck : Node = $"Ground Check"

#var _inventory = load("res://Game/Modules/Player/Scripts/Inventory.gd").new()

var _canMove : bool = true

var _speed = 4

var _xVel = 0
var _xKeys = []

var _zVel = 0
var _zKeys = []

var _gravity = -3

var mapXPos = 5
var mapXNeg = 5
var mapZPos = 5
var mapZNeg = 5

func _physics_process(_delta: float) -> void:
	if position.x > mapXPos: position.x = mapXPos
	if position.x < mapXNeg: position.x = mapXNeg
	if position.z > mapZPos: position.z = mapZPos
	if position.z < mapZNeg: position.z = mapZNeg
	
	_canMove = _groundCheck.is_colliding()
	
	if Input.is_action_just_pressed("ui_left"): _xKeys.append(-1)
	if Input.is_action_just_pressed("ui_right"): _xKeys.append(1)
	if Input.is_action_just_pressed("ui_up"): _zKeys.append(-1)
	if Input.is_action_just_pressed("ui_down"): _zKeys.append(1)
	
	if Input.is_action_just_released("ui_left"): _xKeys.erase(-1)
	if Input.is_action_just_released("ui_right"): _xKeys.erase(1)
	if Input.is_action_just_released("ui_up"): _zKeys.erase(-1)
	if Input.is_action_just_released("ui_down"): _zKeys.erase(1)
	
	_xVel = 0
	for key in _xKeys.size():
		_xVel += _xKeys[key] * (key + 1)
	
	_zVel = 0
	for key in _zKeys.size():
		_zVel += _zKeys[key] * (key + 1)
	
	var velNorm = Vector2(_xVel * int(_canMove), _zVel * int(_canMove)).normalized()
	velocity = Vector3((velNorm.x * _speed), _gravity * int(!_canMove), (velNorm.y * _speed))
	
	if (_xKeys + _zKeys).size() > 0:
		rotation.y = atan2(velocity.x * -1, velocity.z * -1)
	move_and_slide()
