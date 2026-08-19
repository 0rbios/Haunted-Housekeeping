extends Node

# Assembles the map. Including ghosts, dirt and players.

var _mLoad = preload("res://Game/Modules/Map/Scripts/MAP_LOADER.gd").new()

# Takes in the map data and applies it to the scene.
func buildScene() -> void:
	_mLoad.loadMap(_mLoad.readMap("res://Game/Maps/DEBUG.json"))

func _ready() -> void:
	var base = $Base
	
	buildScene()
	
	var player = load("res://Game/Modules/Player/Player.tscn").instantiate()
	player.position = Vector3(0.0, 0.1, 0.0)
	player.mapXPos = base.position.x + (base.scale.x / 2)
	player.mapXNeg = base.position.x - (base.scale.x / 2)
	player.mapZPos = base.position.z + (base.scale.z / 2)
	player.mapZNeg = base.position.z - (base.scale.z / 2)
	self.call_deferred("add_child", player)
	
	var camera = load("res://Game/Modules/Camera/Camera.tscn").instantiate()
	camera.NodeToTrack = player
	self.call_deferred("add_child", camera)
	
	camera.make_current()
