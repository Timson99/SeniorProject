extends Node


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
