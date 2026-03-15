extends Node

# Variables --------------------

# Server Settings
const PORT = 6666
const IPADDRESS = "localhost"
var peer = ENetMultiplayerPeer.new()

# Functions --------------------

func _ready():
	if MultiplayerSettings.clientType == "host":
		create_server()
	elif MultiplayerSettings.clientType == "client":
		create_client()

func create_server():
	peer.create_server(PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

func create_client():
	peer.create_client(IPADDRESS, PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer
