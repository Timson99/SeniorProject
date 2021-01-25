extends Node

# member variables
onready var animations = $AnimatedSprite
onready var interact_area = $Area2D
var party = []

export var persistence_id = "" 
export var item_id = ""
export var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_area.connect("body_entered", self, "body_entered")
	interact_area.connect("body_exited", self, "body_exit")
	party = get_tree().get_nodes_in_group("Party")
	
func interact():
	if !opened:
		animations.play("closed_to_open")
		yield(animations, "animation_finished")
		animations.play("open")
		opened = true
		if(item_id != ""):
			DialogueEngine.item_message(item_id)
			if party.size() == 1:
				party[0].items.append(item_id)

func body_entered(body):
	if party.size() == 1 && body == party[0].active_player && !opened:
		body.interact_areas.append(self)

func body_exit(body):
	if party.size() == 1 && body == party[0].active_player:
			if self in body.interact_areas:
				body.interact_areas.erase(self)
				
func save():
	if(persistence_id != ""):
		return {
			"persistence_id" : persistence_id,
			"opened" : opened
		}
	else:
		return {}
	
func on_load():
	if opened:
		animations.play("open")
		interact_area.disconnect("body_entered", self, "body_entered")
		interact_area.disconnect("body_exited", self, "body_exit")
