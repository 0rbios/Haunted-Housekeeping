extends Node

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
@onready var DEBUGROOT = $".."

@export var networkPlayer: PackedScene

# Functions --------------------

func _ready():
	multiplayer.peer_disconnected.connect(delete_player)

func spawn_players():
	for player in legend.find_active_room().players:
		var playerInstance = networkPlayer.instantiate()
		playerInstance.name = str(player)
		playerInstance.position.y = 0.6
		$"..".call_deferred("add_child", playerInstance)

@rpc("any_peer", "call_local")
func delete_player(id: int):
	if DEBUGROOT.get_node(str(id)):
		DEBUGROOT.get_node(str(id)).call_deferred("queue_free")
	else:
		return

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		var myID = multiplayer.get_unique_id()
		legend.leave_room.rpc_id(1, legend.activeRoom, myID)
		for player in legend.find_active_room().players:
			delete_player.rpc_id(player, myID)
		legend.clean_tree()
