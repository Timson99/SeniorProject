extends Node

var game_paused = false
var input_paused = false

func _ready():
	pass # Replace with function body.
	
func player_control_enabled():
	return !game_paused && !input_paused

