extends Node


func _ready():
	pass # Replace with function body.
	
var pressed = false

func _process(delta):
	if(!pressed && Input.is_action_just_pressed("ui_accept")):
		SceneManager.goto_scene("LoadScreen")
		pressed = true
