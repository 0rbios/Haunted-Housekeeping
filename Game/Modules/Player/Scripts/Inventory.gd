extends Node

var _items : Dictionary = {
	1 : null,
	2 : null,
	3 : null
}

var _selectedIndex = 1

func AddItem(object) -> void:
	# Drop the currently held item
	if !_items[_selectedIndex] == null:
		DropItem(_items[_selectedIndex])
	
	_items[_selectedIndex] = object

func DropItem(_object) -> void:
	pass
