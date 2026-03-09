extends Node

const PORT = 6666
const IPADDRESS = "localhost"

const PLAYER = preload("res://Objects/Player/player.tscn")
const CAM = preload("res://Objects/Camera/camera.tscn")

func _ready():
	if MultiplayerSettings.clientType == "host":
		create_server()
		spawn_player(multiplayer.get_unique_id())
	else:
		create_client()

func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer

func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IPADDRESS, PORT)
	multiplayer.multiplayer_peer = peer

func spawn_player(playerID: int):
	var player = PLAYER.instantiate()
	player.name = str(playerID)
	$"..".add_child.call_deferred(player)
	
	var camera = CAM.instantiate()
	camera.name = str(playerID) + "Cam"
	camera.following = player
	$"..".add_child.call_deferred(camera)
