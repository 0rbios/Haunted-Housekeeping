extends Node

# Reads a given map file and handles any relevant actions from it.

# User defined list of valid scene items.
@export var items : Array[PackedScene] = []

# Takes in the map file and outputs the raw data.
func readMap(mapFile : String) -> Array:
	var json = JSON.new()
	
	var rawData = FileAccess.open(mapFile, FileAccess.READ)
	var stringData = rawData.get_as_text()
	json.parse(stringData)
	var mapData = json.data
	
	return mapData

# Takes the raw data, cleans it up and defaults out any missing or broken data.
func loadMap(data : Array) -> void:
	var cleanData = []
	
	for datapoint in data:
		# Give up on any item that doesn't have a type in the valid item list
		if "type" not in datapoint.keys(): continue
		var foundItem = _findType(datapoint["type"])
		if foundItem == null: continue
		
		# Check for an then run the items cleanup script
		if "clean" in foundItem:
			cleanData.append(foundItem.clean())

func _findType(iType : String) -> PackedScene:
	for item in items:
		if "type" in item:
			if item.type == iType:
				return item
	return null
