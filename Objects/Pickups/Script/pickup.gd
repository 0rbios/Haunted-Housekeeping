extends RigidBody3D

# Variables --------------------

# Unique ID
@export var pickupType: String
@export var nodeName: String

# Carrying
@export var carriedBy = null
@onready var pivot = $".."

# Functions --------------------

# Making Names Consistent Across Clients/Server
func _ready():
	pivot.name = nodeName

# If The Current Game Instance (Client/Server) Is The Owner Of This Object, Manage The Physics And Positioning Of The Object
func _physics_process(_delta):
	if is_multiplayer_authority():
		self.freeze = linear_velocity.y == 0
		
		if carriedBy != null:
			pivot.position = carriedBy.position
			pivot.rotation = carriedBy.rotation
