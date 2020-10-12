extends Node

<<<<<<< Updated upstream
=======
var to_player_commands := {
	"pressed": 
		{"ui_up" : "move_up",
		"ui_down" : "move_down",
		"ui_left" : "move_left",
		"ui_right" : "move_right"
		},
	"just_pressed": 
		{"ui_up" : "up_just_pressed",
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "save_game",
		 #Test Command
		"ui_test" : "test_command"
		},
	"just_released": 
		{"ui_down" : "down_just_released",
		},
}

var to_dialogue_commands : Dictionary = {
		"pressed": 
		{
		},
	"just_pressed": 
		{
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "ui_accept_pressed",
		},
	"just_released": 
		{
		},
}

var valid_receivers := {
	"Debug_Menu" : {"priority": 1, "loop": "_process", "translator" : to_player_commands},
	"Battle Menu" : {"priority": 2, "loop": "_process", "translator" : to_player_commands},
	"Dialogue" : {"priority": 3, "loop": "_process", "translator" : to_player_commands},
	"Menu" : {"priority": 4, "loop": "_process", "translator" : to_player_commands},
	"Player" : {"priority": 5, "loop": "_physics_process", "translator" : to_player_commands},
	"Test_Item" : {"priority": 6, "loop": "_process", "translator" : to_player_commands},
}

var input_disabled := false
var input_target = null
const group_name := "Input_Receiver"

var disabled = []

>>>>>>> Stashed changes

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var playerCommandDict = {
	
	
}

var dialogueCommandDict = {
	
	
}

var currentCommandDict = playerCommandDict

var actions = ["ui_accept", "ui_cancel"]

var InputRecievers = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var command = ""
	
	for action in actions:
		if(Input.is_action_just_pressed(action)):
			command = currentCommandDict["action"]
			
	if command != "":
		InputRecievers[0].call_deferred("command")
	
"""
