extends RigidBody3D
var type = "object"

func clean(data : Dictionary) -> void:
	if "position" in data.keys():
		var cleanPos = []
		
		for p in data["position"]:
			if p is int or p is float:
				cleanPos.append(p)
		
		for empty in range(3 - cleanPos.size()):
			cleanPos.append(0)
		
		cleanPos.resize(3)
		
		position = Vector3(cleanPos[0], cleanPos[1], cleanPos[2])
