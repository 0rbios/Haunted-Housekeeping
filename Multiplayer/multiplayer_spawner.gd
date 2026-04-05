extends Node

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)

@export var networkPlayer: PackedScene

# Functions --------------------

# Set Up Links To Spawn And Delete Player Characters On All Game Instances
# When Players Join Or Leave Game
func _ready():
	pass
	#multiplayer.peer_connected.connect(spawn_player)
	#multiplayer.peer_disconnected.connect(delete_player)

func spawn_players():
	for player in legend.find_active_room().players:
		var playerInstance = networkPlayer.instantiate()
		playerInstance.name = str(player)
		$"..".call_deferred("add_child", playerInstance)

#func delete_player(id: int):
	#if not get_node(spawn_path).has_node(str(id)):
		#return
	#get_node(spawn_path).get_node(str(id)).call_deferred("queue_free")

#func _input(_event: InputEvent):
	#if Input.is_action_just_pressed("ui_cancel"):
		#multiplayer.multiplayer_peer.disconnect_peer(1)
