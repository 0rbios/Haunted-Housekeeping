extends RigidBody3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
var auth
var myID

# Unique ID
var pickupType: String

# Carrying
var carriedBy = null
@onready var pivot = $".."

# Functions --------------------

# Making Names Consistent Across Clients/Server
func _ready():
	myID = multiplayer.get_unique_id()

func _process(_delta):
	if typeof(legend.find_active_room()) != TYPE_NIL:
		if !legend.find_active_room().players.has(auth):
			auth = legend.find_active_room().owner
			self.position = Vector3(0, 0, 0)
	
	if myID != auth:
		return
	
	if typeof(legend.find_active_room()) != TYPE_NIL:
		for player in legend.find_active_room().players:
			synchronise.rpc_id(player, pivot.position, pivot.rotation, self.position, self.rotation)

@rpc("any_peer", "call_local")
func synchronise(authPivotPos, authPivotRot, authPos, authRot):
	pivot.position = authPivotPos
	pivot.rotation = authPivotRot
	self.position = authPos
	self.rotation = authRot

# If The Current Game Instance (Client/Server) Is The Owner Of This Object, Manage The Physics And Positioning Of The Object
func _physics_process(_delta):
	if myID == auth:
		self.freeze = linear_velocity.y == 0
		
	if carriedBy != null:
		if carriedBy.name == str(myID):
			pivot.position = carriedBy.position
			pivot.rotation = carriedBy.rotation
		elif carriedBy.is_in_group("ghost") and myID == auth:
			pivot.position = carriedBy.position
			pivot.rotation = carriedBy.rotation
