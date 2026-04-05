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
				legend.join_room.rpc_id(1, room.name, multiplayer.get_unique_id())
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
		legend.create_room.rpc_id(1, str(nameEntry.text.remove_chars(" ")), str(codeEntry.text.remove_chars(" ")), multiplayer.get_unique_id())
		legend.activeRoom = str(nameEntry.text.remove_chars(" "))
		legend.clean_tree(roomMenu)

func _checkForExisting():
	for room in legend.rooms:
		if room.name == nameEntry.text.remove_chars(" "):
			return true
