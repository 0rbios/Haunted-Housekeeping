extends Node

# Assembles the map. Including ghosts, dirt and players.

var mLoad = preload("res://Game/Modules/Map/Scripts/MAP_LOADER.gd").new()

# Takes in the map data and applies it to the scene.
func buildScene() -> void:
	mLoad.loadMap(mLoad.readMap("res://Game/Maps/DEBUG.json"))

func _ready() -> void:
	buildScene()
	
	var player = load("res://Game/Modules/Player/Player.tscn").instantiate()
	player.position = Vector3(0.0, 0.1, 0.0)
	self.call_deferred("add_child", player)
