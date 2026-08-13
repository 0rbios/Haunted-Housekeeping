extends Control

# Server Settings
const PORT = 6666
var peer = ENetMultiplayerPeer.new()
@onready var ipEntry = $"IP Entry"

func _ready():
	if OS.has_feature("dedicated_server"):
		get_tree().change_scene_to_file.call_deferred("res://Multiplayer/legend_tree.tscn")
	else:
		create_client()

func create_client():
	peer.create_client(ipEntry.text, PORT)
	multiplayer.multiplayer_peer = peer

func _connect_pressed():
	get_tree().change_scene_to_file("res://Multiplayer/legend_tree.tscn")
