extends RigidBody3D

# Variables --------------------

# Movement
var speed = 5

# Modules
var rng = RandomNumberGenerator.new()

# Holding
var objects
var pickupObject
var carryingNode = null

# Functions --------------------

func _ready():
	_choose_action()

func _rest_over():
	_choose_action()

func _physics_process(_delta):
	if carryingNode != null:
		carryingNode.rotation = self.rotation
		carryingNode.position = Vector3(self.position.x, self.position.y + 1, self.position.z)

func _choose_action():
	match rng.randi_range(0, 2):
		0: _move_to(_generate_random_pos(-50, 50, -50, 50), "cont")
		1: $"Rest Timer".start()
		2: _pickup()

func _generate_random_pos(minX, maxX, minZ, maxZ):
	return Vector3(rng.randf_range(minX, maxX), 0.6, rng.randf_range(minZ,maxZ))

func _move_to(pos, next):
	var tween = get_tree().create_tween()
	
	match next:
		"cont": tween.connect("finished", _choose_action)
		"grab": tween.connect("finished", _move_finished_grab)
	
	var travelTime = sqrt(((pos.x - self.position.x) ** 2) + ((pos.z - self.position.z) ** 2)) / speed
	tween.tween_property(self, "position", pos, travelTime)

func _move_finished_grab():
	if pickupObject.carriedBy == null:
		pickupObject.carriedBy = self
		carryingNode = pickupObject
	_choose_action()

func _pickup():
	if carryingNode != null:
		carryingNode.drop()
		carryingNode = null
		_choose_action()
	else:
		# IF NO ITEMS ARE EVER CREATED OR DESTROYED THEN THIS SHOULD BE MOVED TO _READY
		objects = get_tree().get_nodes_in_group("object")
	
		var objectDistanceList = []
		var distanceList = []
	
		for i in range(objects.size()):
			if objects[i].carriedBy == null:
				var objectDistance = sqrt(((objects[i].position.x - self.position.x) ** 2)+ ((objects[i].position.z - self.position.z)** 2))
				objectDistanceList.push_back({"node": objects[i], "distance": objectDistance}) 
				distanceList.push_back(objectDistance) 
		
		if distanceList.size() > 0:
			pickupObject = objectDistanceList[distanceList.find(distanceList.min())].node
			_move_to(Vector3(pickupObject.position.x, 0.6, pickupObject.position.z), "grab")
		else:
			_choose_action()

func _collision_detected(body):
	if body.is_in_group("player") and body.dashing:
		if carryingNode != null:
			carryingNode.drop()
			carryingNode = null
