extends Area3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
var auth
var myID

@export var cleanedBy: Array

# Functions ------------------

func _ready():
	myID = multiplayer.get_unique_id()

@rpc("any_peer", "call_local")
func _synchronise(authVisibility):
	self.visible = authVisibility

func _process(_delta):
	if typeof(legend.find_active_room()) != TYPE_NIL:
		auth = legend.find_active_room().owner
	
	if myID != auth:
		return
	
	if typeof(legend.find_active_room()) != TYPE_NIL:
		for player in legend.find_active_room().players:
			_synchronise.rpc_id(player, self.visible)

func _collision_detected(body: Node3D):
	if body.is_in_group("object") and Input.is_action_pressed("Use"):
		if cleanedBy.has(body.pickupType):
			_clean_dirt.rpc_id(auth)

@rpc("any_peer", "call_local")
func _clean_dirt():
	self.visible = false
