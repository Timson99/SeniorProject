extends Node

# member variables
onready var animations = $AnimatedSprite
onready var interact_area = $Area2D
var party = []

export var persistence_id = "" 

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_area.connect("body_entered", self, "body_entered")
	interact_area.connect("body_exited", self, "body_exit")
	party = get_tree().get_nodes_in_group("Party")
	
func interact():
	SceneManager.goto_scene("SaveScreen", "", true)

func body_entered(body: KinematicBody2D):
	if party.size() == 1 && body == party[0].active_player:
		body.interact_areas.append(self)

func body_exit(body: KinematicBody2D):
	if party.size() == 1 && body == party[0].active_player:
			if self in body.interact_areas:
				body.interact_areas.erase(self)
				
func save():
	if(persistence_id != ""):
		return {
			"persistence_id" : persistence_id
		}
	else:
		return {}
		
