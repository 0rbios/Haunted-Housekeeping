extends MultiplayerSpawner

@export var networkPlayer: PackedScene
@export var networkCamera: PackedScene

func _ready():
	multiplayer.peer_connected.connect(spawn_player)
	spawn_player(multiplayer.get_unique_id())

func spawn_player(id: int):
	if !multiplayer.is_server(): return
	
	var player = networkPlayer.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player)
