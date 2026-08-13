extends Control

@onready var legend = get_tree().root.find_child("Legend Tree", true, false)
var loadScene : PackedScene

func _ready():
	$Ghost/Animation.current_animation = "Run Across"

func _animation_finished(_anim_name: StringName):
	legend.clean_tree(loadScene)
