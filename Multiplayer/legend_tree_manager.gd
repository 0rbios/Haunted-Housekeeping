extends Node

const mainMenu = preload("res://Maps/Main Menu/main_menu.tscn")

# TEMP
@export var rooms = []
var activeRoom

func _ready():
	clean_tree()

func clean_tree(nextNode = mainMenu):
	var sync = self.find_child("Legend Sync", true, false)
	for node in self.get_children():
		if node != sync:
			self.remove_child(node)
	var nextNodeInstance = nextNode.instantiate()
	self.add_child(nextNodeInstance)
