extends RigidBody3D

# This is to replicate the player variables
var dashing = false

var randPos = Vector3(0, 0, 0)
var speed = 5
var rng = RandomNumberGenerator.new()
var objects

var carrying = false

var pickupPos
var pickupObject

func _ready():
	_choose_action()

func _choose_action():
	var action = rng.randi_range(0, 2)
	
	print("Action: " + str(action))
	
	match action:
		0: 
			_generate_random_pos(-50, 50, -50, 50)
			$CurrentAction.text = "Going to " + str(randPos)
			_move_to(randPos, "cont")
		1:
			$CurrentAction.text = "Waiting"
			$"Rest Timer".start()
		2:
			_pickup()

func _generate_random_pos(minX, maxX, minZ, maxZ):
	randPos = Vector3(rng.randf_range(minX, maxX), 0.6, rng.randf_range(minZ,maxZ))

func _move_to(pos, next):
	var tween = get_tree().create_tween()
	
	match next:
		"cont": tween.connect("finished", _move_finished)
		"grab": tween.connect("finished", _move_finished_grab)
	
	var travelTime = sqrt(((pos.x - self.position.x) ** 2) + ((pos.z - self.position.z) ** 2)) / speed
	print("Movement speed: " + str(travelTime))
	tween.tween_property(self, "position", pos, travelTime)

func _move_finished():
	print("Move to:" + str(randPos) + ", Stopped at: " + str(self.position))
	_choose_action()
	
func _move_finished_grab():
	print("Pickup at:" + str(pickupPos) + ", Stopped at: " + str(self.position))
	pickupObject.carrier = self
	pickupObject.isCarried = true
	carrying = true
	_choose_action()
	
func _rest_over():
	print("Timer Out")
	_choose_action()

func _pickup():
	
	if carrying:
		pickupObject.isCarried = false
		pickupObject.position = Vector3(self.position.x, self.position.y, self.position.z)
		_choose_action()
	else:
		# IF NO ITEMS ARE EVER CREATED OR DESTROYED THEN THIS SHOULD BE MOVED TO _READY
		objects = get_tree().get_nodes_in_group("object")
		
		var findNearest = []
		var pickedObject
		
		for i in range(objects.size()):
			findNearest.push_back(sqrt(((objects[i].position.x - self.position.x) ** 2) + ((objects[i].position.z - self.position.z) ** 2)))
		
		pickedObject = findNearest.find(findNearest.min())
		
		$CurrentAction.text = "Picking up " + str(objects[pickedObject])
		
		pickupPos = Vector3(objects[pickedObject].position.x, 0.6, objects[pickedObject].position.z)
		pickupObject = objects[pickedObject]
		
		_move_to(Vector3(objects[pickedObject].position.x, 0.6, objects[pickedObject].position.z), "grab")
	
