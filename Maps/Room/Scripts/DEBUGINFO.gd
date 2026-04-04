extends Label

@onready var legend = get_tree().root.get_child(0)

func _ready():
	self.text = str(legend.activeRoom)
