extends MultiplayerSpawner

# Variables --------------------

@export var networkPlayer: PackedScene
@export var networkCamera: PackedScene

# Functions --------------------

# Set Up Links To Spawn And Delete Player Characters On All Game Instances
# When Players Join Or Leave Game
func _ready():
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(delete_player)
	spawn_player(multiplayer.get_unique_id())

func spawn_player(id: int):
	if !multiplayer.is_server(): return
	
	var player = networkPlayer.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)

func delete_player(id: int):
	if not get_node(spawn_path).has_node(str(id)):
		return
	get_node(spawn_path).get_node(str(id)).call_deferred("queue_free")

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("ui_cancel"):
		multiplayer.multiplayer_peer.disconnect_peer(1)
		get_tree().change_scene_to_file("res://Maps/Main Menu/main_menu.tscn")
