extends RigidBody3D

var action
var randPos = Vector3(0, 0, 0)
var speed = 5
var rng = RandomNumberGenerator.new()

func _ready():
	_choose_action()

func _choose_action():
	action = rng.randi_range(0, 1)
	
	match action:
		0: 
			_generate_random_pos(-50, 50, -50, 50)
			_move_to()
		1:
			$"Rest Timer".start()

func _generate_random_pos(minX, maxX, minZ, maxZ):
	randPos = Vector3(rng.randf_range(minX, maxX), 0.6, rng.randf_range(minZ,maxZ))

func _move_to():
	var tween = get_tree().create_tween()
	tween.connect("finished", _move_finished)
	var travelTime = sqrt((randPos.x ** 2) + (randPos.z ** 2)) / speed
	print(travelTime)
	tween.tween_property(self, "position", randPos, travelTime)

func _move_finished():
	_choose_action()

func _rest_over():
	_choose_action()
