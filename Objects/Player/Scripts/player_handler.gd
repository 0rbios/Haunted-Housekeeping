extends RigidBody3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
var ownerID
var auth
var myID

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

func _ready():
	myID = multiplayer.get_unique_id()
	auth = int(self.name)

func _process(_delta):
	ownerID = legend.find_active_room().owner
	
	if myID != auth:
		return
	
	for player in legend.find_active_room().players:
		if player != auth:
			_synchronise.rpc_id(player, self.position, self.rotation, carryingNode)

@rpc("any_peer", "call_local")
func _synchronise(authPos, authRot, authCarry):
	self.position = authPos
	self.rotation = authRot
	carryingNode = authCarry

func _physics_process(_delta):
	# Only Handle Movement When The Player Owns The Node
	if myID != auth: return
	
	# "Use" The Held Node (Currently Slows The Player And Puts The Node Infront Of Them)
	if carryingNode != null:
		if Input.is_action_pressed("Use"):
			carryingNode.position.z = -1
			carryingNode.position.y = 0
			activeSpeed = baseSpeed / 2.0
		else:
			carryingNode.position.z = 0
			carryingNode.position.y = 1
			activeSpeed = baseSpeed
	
	# Take Movement Input
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
		
		# Dash Handling
		if Input.is_action_just_pressed("Dash") and velocity != Vector3(0, 0, 0):
			activeSpeed = baseSpeed * 3
			self.set_collision_layer_value(4, true)
			dashing = true
			if carryingNode != null:
				drop()
			$"Dash Timer".start()
	
	# Pick Up Or Drop Held Item
	if Input.is_action_just_pressed("Interact"):
		if carryingNode == null and hoverOver != null:
			pickup()
		elif carryingNode != null:
			drop()
	
	# Movement Actuation
	var toBeNormalized = Vector2(horizontal, long).normalized()
	velocity = Vector3(toBeNormalized.x * activeSpeed, 0, toBeNormalized.y * activeSpeed)
	apply_force(velocity)
	
	# Rotate In Movement Direction
	if velocity != Vector3(0, 0, 0):
		look_at(self.global_position + velocity)

# Reset After Dashing
func _dash_complete():
	self.set_collision_layer_value(4, false)
	activeSpeed = baseSpeed
	dashing = false

# Signal For Updating Pickup Authority So It Can be Controlled Correctly
@rpc("any_peer", "call_local")
func change_auth(node, id):
	get_node(node).auth = id

func pickup():
	carryingNode = hoverOver
	for player in legend.find_active_room().players:
		change_auth.rpc_id(player, carryingNode.get_path(), myID)
		carryingNode.synchronise.rpc_id(player, self.position, carryingNode.pivot.rotation, Vector3(0, 0, 0), carryingNode.rotation)
	carryingNode.freeze = true
	carryingNode.carriedBy = self

func drop():
	carryingNode.position = Vector3(0, 0, 0)
	carryingNode.pivot.position = self.position
	carryingNode.carriedBy = null
	carryingNode.synchronise.rpc_id(ownerID, self.position, carryingNode.pivot.rotation, Vector3(0, 0, 0), carryingNode.rotation)
	for player in legend.find_active_room().players:
		change_auth.rpc_id(player, carryingNode.get_path(), ownerID)
	carryingNode = null

func _touching_node(body):
	if body.is_in_group("object"):
		hoverOver = body

func _leave_node(body):
	if body.is_in_group("object"):
		hoverOver = null
