extends Control

# Variables --------------------

@onready var legend = get_tree().root.get_child(0)
@onready var roomName = $"CanvasLayer/Room Name"

# Functions --------------------

func _ready():
	roomName.text = str(legend.activeRoom)

func _player_leaving():
	_leave_room.rpc_id(1, legend.activeRoom, multiplayer.get_unique_id())
	legend.clean_tree()

@rpc("any_peer", "call_local")
func _leave_room(roomName, playerID):
	for room in legend.rooms:
		if room.name == roomName:
			if str(playerID) == room.owner:
				if room.players.size() > 1:
					room.players.remove_at(room.players.find(str(playerID)))
					room.owner = room.players[0]
				else:
					legend.rooms.remove_at(legend.rooms.find(room))
			else:
				room.players.remove_at(room.players.find(playerID))
	print("Player Left Room " + roomName + ", Updated Room List:")
	print(legend.rooms)
