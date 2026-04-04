extends Control

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
@onready var roomNameText = $"CanvasLayer/Room Name"

# Functions --------------------

func _ready():
	multiplayer.peer_disconnected.connect(player_disconnecting)
	roomNameText.text = str(legend.activeRoom)

func _player_leaving():
	_leave_room.rpc_id(1, legend.activeRoom, multiplayer.get_unique_id())
	legend.clean_tree()

func player_disconnecting(id: int):
	if multiplayer.get_unique_id() == 1:
		for room in legend.rooms:
			if room.players.has(str(id)):
				if str(id) == room.owner:
					if room.players.size() < 2:
						legend.rooms.remove_at(legend.rooms.find(room))
					else:
						room.players.remove_at(room.players.find(str(id)))
						room.owner = room.players[0]
				else:
					room.players.remove_at(room.players.find(str(id)))
		print("Player Left Room, Updated Room List:")
		print(legend.rooms)

@rpc("any_peer", "call_local")
func _leave_room(roomName, playerID):
	for room in legend.rooms:
		if room.name == roomName:
			if str(playerID) == room.owner:
				if room.players.size() < 2:
					print(legend.rooms.find(room))
					legend.rooms.remove_at(legend.rooms.find(room))
				else:
					room.players.remove_at(room.players.find(str(playerID)))
					room.owner = room.players[0]
			else:
				room.players.remove_at(room.players.find(str(playerID)))
	print("Player Left Room, Updated Room List:")
	print(legend.rooms)
