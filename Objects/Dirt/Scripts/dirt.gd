extends Area3D

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
var auth
@onready var sync = $MultiplayerSynchronizer
var syncedPlayers = []

@export var cleanedBy: Array

# Functions ------------------

func _ready():
	for player in legend.find_active_room().players:
		sync.set_visibility_for(player, true)
	auth = legend.find_active_room().owner

func _process(_delta):
	for player in syncedPlayers:
		if !legend.find_active_room().players.has(player):
			sync.set_visibility_for(player, false)
			syncedPlayers.remove_at(syncedPlayers.find(player))
	for player in legend.find_active_room().players:
		if !syncedPlayers.has(player):
			sync.set_visibility_for(player, true)
			syncedPlayers.push_back(player)

func _collision_detected(body: Node3D):
	if body.is_in_group("object") and Input.is_action_pressed("Use"):
		if cleanedBy.has(body.pickupType):
			_clean_dirt.rpc_id(auth)

@rpc("any_peer", "call_local")
func _clean_dirt():
	self.visible = false
