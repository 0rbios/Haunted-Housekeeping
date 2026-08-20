extends Node

# Reads a given map file and handles any relevant actions from it.

var map : Node

# User defined list of valid scene items.
var items : Array[PackedScene] = [load("res://Game/Modules/Object/Object.tscn")]

# Takes in the map file and outputs the raw data.
func readMap(mapFile : String) -> Array:
	var json = JSON.new()
	
	var rawData = FileAccess.open(mapFile, FileAccess.READ)
	var stringData = rawData.get_as_text()
	json.parse(stringData)
	var mapData = json.data
	
	return mapData

# Takes the raw data, cleans it up and defaults out any missing or broken data.
func loadMap(data : Array) -> Dictionary:
	var mapConfig = {}
	
	if map == null: return mapConfig
	
	for datapoint in data:
		# Give up on any item that doesn't have a type in the valid item list
		if "type" not in datapoint.keys(): continue
		
		if datapoint["type"] == "map":
			mapConfig = datapoint
		
		var foundItem = _findType(datapoint["type"])
		if foundItem == null: continue
		
		# Check for and then run the items cleanup script
		var itemInstance = foundItem.instantiate()
		if itemInstance.has_method("clean"):
			map.call_deferred("add_child", itemInstance)
			itemInstance.clean(datapoint)
		else:
			itemInstance.queue_free()
		
	return mapConfig

func _findType(iType : String) -> PackedScene:
	for item in items:
		var testInstance = item.instantiate()
		if "type" in testInstance:
			if testInstance.type == iType: 
				return item
		testInstance.queue_free()
	return null
