extends Node

# Variables --------------------

# Refrences
const mainMenu = preload("res://Maps/Main Menu/main_menu.tscn")
const loadScreen = preload("res://Maps/Loading Screen/load_screen.tscn")

# Server Settings
const PORT = 6666
var peer = ENetMultiplayerPeer.new()

# Room Managment
@export var rooms = []
var activeRoom

# Functions --------------------

# Delete All Legend Children Except For Synchroniser And Load New Scene
func clean_tree(nextNode = mainMenu):                                           # Takes A Map Argument, Defaults To The Main Menu
	if !multiplayer.is_server():                                                # Only Runs On Clients
		var sync = self.find_child("Legend Sync", true, false)
		for node in self.get_children():
			if node != sync:
				node.queue_free()
		var nextNodeInstance = nextNode.instantiate()
		self.call_deferred("add_child", nextNodeInstance)

func load_screen(nextScene = mainMenu):
	if !multiplayer.is_server():
		var loadScreenInstance = loadScreen.instantiate()
		loadScreenInstance.loadScene = nextScene
		self.add_child(loadScreenInstance)

# Gets The Local IP Adress From The Dedicated Server Computer
func get_local_ip():
	var addresses = IP.get_local_addresses()
	for ip in addresses:
		# Filter for IPv4 and avoid loopback (127.0.0.1) or self refrencing
		if ip.split(".").size() == 4 and not ip.begins_with("127") and not ip.begins_with("169"):
			return ip
	return "IP not found"

# Creates A Server On The Dedicated Server Version And A Client On Anything Else
func _ready():
	multiplayer.peer_disconnected.connect(player_disconnecting)
	
	if OS.has_feature("dedicated_server"):
		create_server()
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

func player_disconnecting(id: int):
	if multiplayer.is_server():
		for room in rooms:
			if room.players.has(id):
				if id == room.owner:
					if room.players.size() < 2:
						rooms.remove_at(rooms.find(room))
					else:
						room.players.remove_at(room.players.find(id))
						room.owner = room.players[0]
				else:
					room.players.remove_at(room.players.find(id))

@rpc("any_peer", "call_local")
func leave_room(roomName, playerID):
	for room in rooms:
		if room.name == roomName:
			if playerID == room.owner:
				if room.players.size() < 2:
					rooms.remove_at(rooms.find(room))
				else:
					room.players.remove_at(room.players.find(playerID))
					room.owner = room.players[0]
			else:
				room.players.remove_at(room.players.find(playerID))
	activeRoom = null

@rpc("any_peer", "call_remote")
func update_owner_clientside():
	var roomMenu = load("res://Maps/Room/Room.tscn")
	clean_tree(roomMenu)

@rpc("any_peer", "call_local")
func load_map():
	var debug = load("res://Temp/debug.tscn")
	clean_tree(debug)

@rpc("any_peer", "call_local")
func create_room(roomName: String, roomCode: String, roomOwner: int):
	rooms.push_back({"name": roomName, "code": roomCode, "owner": roomOwner, "players": [roomOwner], "started": false})

@rpc("any_peer", "call_local")
func join_room(roomName: String, playerID: int):
	for room in rooms:
		if room.name == roomName:
			room.players.push_back(playerID)

@rpc("any_peer", "call_local")
func start_game(roomName):
	for room in rooms:
		if room.name == roomName:
			room.started = true

func find_active_room():
	for room in rooms:
		if room.name == activeRoom:
			return room
