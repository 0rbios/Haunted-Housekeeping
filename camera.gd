extends Camera3D

@onready var player = $"../Player"

var dashX
var dashZ

func _physics_process(_delta):
	self.position.x = player.position.x
	self.position.z = player.position.z + 4
	
	if Input.is_action_just_pressed("ui_accept"):
		dashX = self.position.x
		dashZ = self.position.z
