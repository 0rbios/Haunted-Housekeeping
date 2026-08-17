extends Node
var modName : String = 'scene'

# Loads and changes between scenes.

func swap(scene : String) -> void:
	for child in self.get_children():
		child.queue_free()
	
	var scenePacked = load(scene)
	var sceneInstance = scenePacked.instantiate()
	self.call_deferred("add_child", sceneInstance)

# Loads the starting scene when the game loads.
func _ready() -> void:
	swap("res://Game/Modules/Map/Map.tscn")
