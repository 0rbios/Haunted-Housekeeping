extends Node3D

@onready var legend = get_tree().root.get_child(0)
@onready var spawner = $"Player Spawner"
var entityDataRaw = FileAccess.get_file_as_string("res://Entity Loadstates/DEBUG.json")
var entityData = JSON.parse_string(entityDataRaw)

func _ready():
	if legend.find_active_room().players.has(multiplayer.get_unique_id()):
		for entity in entityData:
			match entity.type:
				"ghost":
					var ghostScene = load("res://Objects/Ghost/ghost.tscn")
					var ghostInstance = ghostScene.instantiate()
					ghostInstance.position = Vector3(entity.position[0], entity.position[1], entity.position[2])
					self.add_child(ghostInstance)
		self.set_multiplayer_authority(legend.find_active_room().owner, true)
		spawner.spawn_players()
