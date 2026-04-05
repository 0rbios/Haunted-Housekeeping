extends RigidBody3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)

# Movement
var speed = 5

# Modules
var rng = RandomNumberGenerator.new()

# Holding
var objects
var pickupObject
@export var carryingNode = null

# Multiplayer
var canChoose = false

# Functions --------------------

func _ready():
	var sync = $"Ghost Synchronizer"
	for player in legend.find_active_room().players:
		sync.set_visibility_for(player, true)

# When The Ghost Finishes Waiting, Chooses Its Next Action
func _rest_over():
	_choose_action()

# An Overly Complicated Way To Stop Ghosts From Having AI On Clients
func _physics_process(_delta):
	if multiplayer.is_server() and canChoose == false:
		canChoose = true
		_choose_action()

# Picks One Of A List Of Possible Actions
func _choose_action():
	match rng.randi_range(0, 2):
		0: _move_to(_generate_random_pos(-50, 50, -50, 50), "cont")
		1: $"Rest Timer".start()
		2: _pickup()

# Picks A Random Position On The Map
func _generate_random_pos(minX, maxX, minZ, maxZ):
	return Vector3(rng.randf_range(minX, maxX), 0.6, rng.randf_range(minZ,maxZ))

# Creates An Animation, Checks What To Do After, How Long To Move For, Then Goes
func _move_to(pos, next):
	var tween = get_tree().create_tween()
	
	match next:
		"cont": tween.connect("finished", _choose_action)
		"grab": tween.connect("finished", _move_finished_grab)
	
	var travelTime = sqrt(((pos.x - self.position.x) ** 2) + ((pos.z - self.position.z) ** 2)) / speed
	tween.tween_property(self, "position", pos, travelTime)

# If The Ghost Has To Pick Up An Object After Moving, Check If The Target Object Is Being Held By Someone Else, Pick It Up If Not
func _move_finished_grab():
	if pickupObject.carriedBy == null:
		_pickup_node()
	_choose_action()

# If The Ghost Is Holding An Object, Drop It. Otherwise, Find The Nearest Object And Move To It
func _pickup():
	if carryingNode != null:
		_drop_node.rpc_id(1)
		_choose_action()
	else:
		# IF NO ITEMS ARE EVER CREATED OR DESTROYED THEN THIS SHOULD BE MOVED TO _READY
		objects = get_tree().get_nodes_in_group("object")
	
		var objectDistanceList = []
		var distanceList = []
	
		for i in range(objects.size()):
			if objects[i].carriedBy == null:
				var objectDistance = sqrt(((objects[i].position.x - self.position.x) ** 2)+ ((objects[i].position.z - self.position.z)** 2))
				objectDistanceList.push_back({"node": objects[i], "distance": objectDistance}) 
				distanceList.push_back(objectDistance) 
		
		if distanceList.size() > 0:
			pickupObject = objectDistanceList[distanceList.find(distanceList.min())].node
			_move_to(Vector3(pickupObject.pivot.position.x, 0.6, pickupObject.pivot.position.z), "grab")
		else:
			_choose_action()

# If The Player Dashes Into The Ghost, The Ghost Drops Any Held Objects
func _collision_detected(body):
	if body.is_in_group("player") and body.dashing:
		_drop_node.rpc_id(1)

# Set The Ghost's Held Object To Its Target And Set The Target's Holder To The Ghost
func _pickup_node():
	carryingNode = pickupObject
	carryingNode.position = Vector3(0, 1, 0)
	carryingNode.carriedBy = self

# Move The Held Object To The Ground At The Ghost's Position, And Unassign All Links/References Between the Ghost And Object
@rpc("any_peer", "call_local")
func _drop_node():
	if carryingNode != null:
		carryingNode.position = Vector3(0, 0, 0)
		carryingNode.pivot.position = self.position
		carryingNode.carriedBy = null
		carryingNode = null
