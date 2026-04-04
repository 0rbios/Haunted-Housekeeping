extends Node

# Variables --------------------

# Refrence To Load Main Menu
const mainMenu = preload("res://Maps/Main Menu/main_menu.tscn")

# Server Settings
const PORT = 6666
var peer = ENetMultiplayerPeer.new()

# Room Managment
@export var rooms = []
var activeRoom

# Functions --------------------

func clean_tree(nextNode = mainMenu):
	var sync = self.find_child("Legend Sync", true, false)
	for node in self.get_children():
		if node != sync:
			self.remove_child(node)
	var nextNodeInstance = nextNode.instantiate()
	self.add_child(nextNodeInstance)

func get_local_ip():
	var addresses = IP.get_local_addresses()
	for ip in addresses:
		# Filter for IPv4 and avoid loopback (127.0.0.1) or self refrencing
		if ip.split(".").size() == 4 and not ip.begins_with("127") and not ip.begins_with("169"):
			return ip
	return "IP not found"

func _ready():
	if OS.has_feature("dedicated_server"):
		print("Starting dedicated server...")
		create_server()
		_load_menus()
	else:
		create_client()
		clean_tree()

func create_server():
	print("Server started at IP: " + get_local_ip())
	peer.create_server(PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

func create_client():
	peer.create_client("127.0.0.1", PORT)
	multiplayer.multiplayer_peer = peer

func _load_menus():
	var roomMenu = load("res://Maps/Room/Room.tscn")
	
	var mainMenuInstance = mainMenu.instantiate()
	var roomMenuInstance = roomMenu.instantiate()
	
	self.add_child(mainMenuInstance)
	self.add_child(roomMenuInstance)
