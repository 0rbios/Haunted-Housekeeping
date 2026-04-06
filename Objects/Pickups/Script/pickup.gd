extends RigidBody3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
var auth

# Unique ID
var pickupType: String

# Carrying
var carriedBy = null
@onready var pivot = $".."

# Functions --------------------

# Making Names Consistent Across Clients/Server
func _ready():
	var sync = $"../MultiplayerSynchronizer"
	for player in legend.find_active_room().players:
		sync.set_visibility_for(player, true)
	auth = legend.find_active_room().owner

# If The Current Game Instance (Client/Server) Is The Owner Of This Object, Manage The Physics And Positioning Of The Object
func _physics_process(_delta):
	if multiplayer.get_unique_id() == auth:
		self.freeze = linear_velocity.y == 0
		
	if carriedBy != null:
		if carriedBy.name == str(multiplayer.get_unique_id()):
			pivot.position = carriedBy.position
			pivot.rotation = carriedBy.rotation
		elif carriedBy.is_in_group("ghost") and multiplayer.get_unique_id() == auth:
			pivot.position = carriedBy.position
			pivot.rotation = carriedBy.rotation
