extends RigidBody3D

var randPos = Vector3(0, 0, 0)
var speed = 5

var rng = RandomNumberGenerator.new()

var objects
var pickupObject

var carryingNode = null

func _ready():
	_choose_action()

func _physics_process(_delta):
	if carryingNode != null:
		carryingNode.position = Vector3(self.position.x, self.position.y + 1, self.position.z)

func _choose_action():
	match rng.randi_range(0, 2):
		0: 
			$CurrentAction.text = "Going to " + str(randPos)
			_move_to(_generate_random_pos(-50, 50, -50, 50), "cont")
		1:
			$CurrentAction.text = "Waiting"
			$"Rest Timer".start()
		2:
			_pickup()

func _generate_random_pos(minX, maxX, minZ, maxZ):
	randPos = Vector3(rng.randf_range(minX, maxX), 0.6, rng.randf_range(minZ,maxZ))
	return randPos

func _move_to(pos, next):
	var tween = get_tree().create_tween()
	
	match next:
		"cont": tween.connect("finished", _move_finished)
		"grab": tween.connect("finished", _move_finished_grab)
	
	var travelTime = sqrt(((pos.x - self.position.x) ** 2) + ((pos.z - self.position.z) ** 2)) / speed
	tween.tween_property(self, "position", pos, travelTime)

func _move_finished():
	_choose_action()
	
func _move_finished_grab():
	if pickupObject.carried == false:
		pickupObject.carried = true
		carryingNode = pickupObject
	_choose_action()

func _rest_over():
	_choose_action()

func _pickup():
	var objectDistanceList = []
	var distanceList = []
	
	if carryingNode != null:
		carryingNode.position = self.position
		carryingNode = null
		_choose_action()
	else:
		# IF NO ITEMS ARE EVER CREATED OR DESTROYED THEN THIS SHOULD BE MOVED TO _READY
		objects = get_tree().get_nodes_in_group("object")
		
		for i in range(objects.size()):
			if objects[i].carried == false:
				objectDistanceList.push_back({"distance": sqrt(((objects[i].position.x - self.position.x) ** 2)+ ((objects[i].position.z - self.position.z)** 2)), "node": objects[i]}) 
				distanceList.push_back(sqrt(((objects[i].position.x - self.position.x) ** 2)+ ((objects[i].position.z - self.position.z)** 2))) 
			
		if distanceList.size() > 0:
			pickupObject = objectDistanceList[distanceList.find(distanceList.min())].node
			
			$CurrentAction.text = "Picking up " + str(pickupObject)
		
			_move_to(Vector3(pickupObject.position.x, 0.6, pickupObject.position.z), "grab")
		
		else:
			_choose_action()
