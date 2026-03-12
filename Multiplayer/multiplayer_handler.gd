extends Node

const PORT = 6666
const IPADDRESS = "localhost"

func _ready():
	if MultiplayerSettings.clientType == "host":
		create_server()
	elif MultiplayerSettings.clientType == "client":
		create_client()

func create_server():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

func create_client():
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IPADDRESS, PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer
