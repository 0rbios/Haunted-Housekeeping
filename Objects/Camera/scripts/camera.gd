extends Camera3D

# Variables --------------------

# Camera Switch
var camMode = "normal"

# Camera Target
@onready var following = $".."

# Functions --------------------

# Sets The Player's View To Be The Camera Of Their Player
func _ready():
	self.current = following.name == str(multiplayer.get_unique_id())

func _physics_process(_delta):
	if Input.is_action_just_pressed("SwitchCam"):
		if camMode == "normal":
			camMode = "overview"
		elif camMode == "overview":
			camMode = "normal"
	
	# Makes The Camera Always Face "North"
	self.rotation.y = following.rotation.y * -1
	
	var tween = get_tree().create_tween()
	match camMode:
		"normal": tween.tween_property(self, "global_position", Vector3(following.global_position.x, following.global_position.y + 10, following.global_position.z + 5), 0.3)
		"overview": tween.tween_property(self, "global_position", Vector3(following.global_position.x, following.global_position.y + 50, following.global_position.z + 50), 0.3)
