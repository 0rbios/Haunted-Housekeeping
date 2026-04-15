extends Control

# Variables --------------------
@onready var legend = get_tree().root.get_child(0)
@onready var roomNameText = $"CanvasLayer/Room Name"
@onready var startButton = $"CanvasLayer/Start Button"
@onready var ownerText = $"CanvasLayer/Owner ID"

# Functions --------------------

func _ready():
	if typeof(legend.activeRoom) != TYPE_NIL:
		roomNameText.text = legend.activeRoom
	else:
		roomNameText.text = "If this isn't a server, there's a problem"

func _process(_delta):
	if typeof(legend.find_active_room()) != TYPE_NIL:
		ownerText.text = str(legend.find_active_room().owner)
		if legend.find_active_room().owner == multiplayer.get_unique_id():
			startButton.visible = true
		else:
			startButton.visible = false

# Occurs When A Player Clicks "Leave"
func _player_leaving():
	legend.leave_room.rpc_id(1, legend.activeRoom, multiplayer.get_unique_id())
	for player in legend.find_active_room().players.size():
		legend.update_owner_clientside.rpc_id(player)
	legend.clean_tree()

# Occurs When The Room Owner Clicks "Start"
func _game_started():
	legend.start_game.rpc_id(1, legend.activeRoom)
	for player in legend.find_active_room().players:
		if player != multiplayer.get_unique_id():
			legend.load_map.rpc_id(player)
	legend.load_map()
