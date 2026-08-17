extends Node

# Takes in a list of requested modules, adds them as children and creates a\
# 	reference table of each module.

# Modules should be able to be referenced with [Pointer to this].mod.[name of module]

# This is a user managed list of modules to load, this is how it knows what to load.
# Takes the scene of each manager.
@export var _modList : Array[PackedScene] = []

# This is the reference table, it will be filled as the modules are loaded.
var mod : Dictionary = {}

# Iterates over the given modules and loads them.
# If the module has a different name defined in the module, use that, otherwise\
# 	defaults to the modules node name.
# Then adds the module node to the module reference table as the value to the\
# 	key of the module name.
func _ready() -> void:
	for module in _modList:
		var moduleInstance = module.instantiate()
		var moduleName = moduleInstance.name
		if "modName" in moduleInstance:
			moduleName = moduleInstance.modName
		self.call_deferred("add_child", moduleInstance)
		mod[moduleName] = moduleInstance
