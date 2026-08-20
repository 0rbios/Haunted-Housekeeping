extends Node

# Assembles the map. Including ghosts, dirt and players.

var _mLoad = preload("res://Game/Modules/Map/Scripts/MAP_LOADER.gd").new()
var _validHexAlpha = ['a', 'b', 'c', 'd', 'e', 'f']

# Takes in the map data and applies it to the scene.
func buildScene() -> void:
	var mapConfig = _mLoad.loadMap(_mLoad.readMap("res://Game/Maps/DEBUG.json"))
	var mapColour = ''
	
	if "colour" in mapConfig.keys():
		mapColour = mapConfig["colour"].strip_edges()
	
	var colourLayer = $Base.get_active_material(0)
	colourLayer.albedo_color = _cleanColour(mapColour)

func _ready() -> void:
	var base = $Base
	
	_mLoad.map = self
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

func _cleanColour(inHex : String) -> String:
	var colour = '#'
	
	if inHex.length() - 1 < 6:
		for h in range(6 - (inHex.length() - 1)):
			inHex += 'F'
	
	for h in inHex:
		if h == '#': continue
		
		if h.is_valid_int() or h in _validHexAlpha:
			colour += h
			continue
			
		colour += 'F'
	
	colour = colour.left(7)
	
	return colour
