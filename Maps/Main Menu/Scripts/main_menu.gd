extends Control

# Variables --------------------

# Node Collection
@onready var legend = get_tree().root.get_child(0)
@onready var nameEntry = $"CanvasLayer/Room Name"
@onready var codeEntry = $"CanvasLayer/Room Code"

# Next Scenes
var roomMenu = preload("res://Maps/Room/Room.tscn")

# Functions --------------------

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
	if _checkForExisting():
		print("Room Name Taken")
	elif nameEntry.text.contains(" "):
		print("Room Name Cannot Contain Spaces")
	elif nameEntry.text.remove_chars(" ") == "":
		print("Room Name Required")
	elif codeEntry.text.contains(" "):
		print("Room Code Cannot Contain Spaces")
	elif codeEntry.text.remove_chars(" ") == "":
		print("Room Code Required")
	else:
		_create_room.rpc_id(1, str(nameEntry.text.remove_chars(" ")), str(codeEntry.text.remove_chars(" ")), str(multiplayer.get_unique_id()))
		legend.activeRoom = str(nameEntry.text.remove_chars(" "))
		legend.clean_tree(roomMenu)

func _checkForExisting():
	for room in legend.rooms:
		if room.name == nameEntry.text.remove_chars(" "):
			return true

@rpc("any_peer", "call_local")
func _create_room(roomName, roomCode, roomOwner):
	legend.rooms.push_back({"name": roomName, "code": roomCode, "owner": roomOwner, "players": [roomOwner]})
	print("A New Room Has Been Made")
	print(legend.rooms)

@rpc("any_peer", "call_local")
func _join_room(roomName, playerID):
	for room in legend.rooms:
		if room.name == roomName:
			room.players.push_back(playerID)
	print("Player Joined Room " + roomName + ", Updated Room List:")
	print(legend.rooms)
