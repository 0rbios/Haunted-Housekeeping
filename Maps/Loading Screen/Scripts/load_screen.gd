extends Control

@onready var legend = get_tree().root.get_child(0)
var loadScene : PackedScene

func _ready():
	$Ghost/Animation.current_animation = "Run Across"

func _animation_finished(_anim_name: StringName):
	legend.clean_tree(loadScene)
