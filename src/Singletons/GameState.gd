extends Node

"""
	Global Save Node that holds Game and Area specific data for a given SaveFile
"""

# Area01
var current_attempt := 1


func _ready():
	SaveManager.register(self)
	ActorManager.register(self)
	
func save():
	return {
		"current_attempt" : current_attempt
	}
