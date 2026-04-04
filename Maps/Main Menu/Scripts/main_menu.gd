extends Control

# Variables --------------------

# Server Settings
const PORT = 6666
var peer = ENetMultiplayerPeer.new()

# Node Collection
@onready var legend = get_tree().root.get_child(0)
@onready var nameEntry = $"CanvasLayer/Room Name"
@onready var codeEntry = $"CanvasLayer/Room Code"
@onready var ipEntry = $"CanvasLayer/IP Entry"

# Next Scenes
var roomMenu = preload("res://Maps/Room/Room.tscn")

# Functions --------------------

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
	else:
		create_client()

func create_server():
	print("Server started at IP: " + get_local_ip())
	peer.create_server(PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

func create_client():
	peer.create_client(ipEntry.text, PORT)
	multiplayer.allow_object_decoding = true
	multiplayer.multiplayer_peer = peer

# Close Game
func _exit_button():
	get_tree().quit()

# Play As Client
func _join_pressed():
	for room in legend.rooms:
		if room.name == nameEntry.text:
			print("Room Found")
			if room.code == codeEntry.text:
				print("Valid Code")
				_join_room.rpc_id(1, room.name, str(multiplayer.get_unique_id()))
				legend.activeRoom = room.name
				legend.clean_tree(roomMenu)
			else:
				print("Incorrect Code")
		else:
			print("Room Does Not Exist")
	

func _make_room_clicked():
	if nameEntry.text.contains(" "):
		print("Room Name Cannot Contain Spaces")
	elif nameEntry.text.remove_chars(" ") == "":
		print("Room Name Required")
	elif codeEntry.text.contains(" "):
		print("Room Code Cannot Contain Spaces")
	elif codeEntry.text.remove_chars(" ") == "":
		print("Room Code Required")
	else:
		print("Room: " + str(nameEntry.text) + " | Owner: " + str(multiplayer.get_unique_id()) + " | Code: " + str(codeEntry.text))
		_create_room.rpc_id(1, str(nameEntry.text), str(codeEntry.text), str(multiplayer.get_unique_id()))
		legend.activeRoom = str(nameEntry.text)
		legend.clean_tree(roomMenu)

@rpc("any_peer", "call_local")
func _create_room(roomName, roomCode, roomOwner):
	legend.rooms.push_back({"name": roomName, "code": roomCode, "owner": roomOwner, "players": [roomOwner]})
	print(str(multiplayer.get_unique_id()) + " A New Room Has Been Made")
	print(legend.rooms)

@rpc("any_peer", "call_local")
func _join_room(roomName, playerID):
	for room in legend.rooms:
		if room.name == roomName:
			room.players.push_back(playerID)
	print("Player Joined Room " + roomName + ", Updated Room List:")
	print(legend.rooms)
