extends Camera3D

var NodeToTrack : Node
var distanceFromNode : float = 5
var cameraMovementLag : float = 0.5

func _ready() -> void:
	if NodeToTrack == null: return
	
	position = NodeToTrack.position + Vector3(0, distanceFromNode, distanceFromNode)
	look_at(NodeToTrack.position)

func _process(_delta : float) -> void:
	var tween = create_tween()
	tween.tween_property(
		self,
		"position",
		NodeToTrack.position + Vector3(0, distanceFromNode, distanceFromNode),
		cameraMovementLag)
