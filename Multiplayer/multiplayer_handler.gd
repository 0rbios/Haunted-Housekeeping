extends Node

# Variables --------------------

# Server Settings
const PORT = 6666
var peer = ENetMultiplayerPeer.new()

# Functions --------------------

func get_local_ip():
	var addresses = IP.get_local_addresses()
	for ip in addresses:
		# Filter for IPv4 and avoid loopback (127.0.0.1)
		if ip.split(".").size() == 4 and not ip.begins_with("127") and not ip.begins_with("169"):
			return ip
	return "IP not found"

func _ready():
	if MultiplayerSettings.clientType == "host":
		create_server()
	elif MultiplayerSettings.clientType == "client":
		create_client()

func create_server():
	print("Server started at IP: " + get_local_ip())
	peer.create_server(PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

func create_client():
	peer.create_client(MultiplayerSettings.Ip, PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer
