extends StaticBody2D

onready var animations = $AnimationPlayer
onready var interact_area = $Area2D
onready var party = get_tree().get_nodes_in_group("Party")
var used = false
var persistence_id = "Area01_Closet"

signal used


func _ready():
	interact_area.connect("body_entered", self, "body_entered")
	interact_area.connect("body_exited", self, "body_exit")
	
func interact():
	if (party.size() == 1 and
		party[0].active_player.has_method("change_skin") and
		party[0].active_player.persistence_id == "C1"):
		party[0].active_player.change_skin("default")
	emit_signal("used")
	animations.play("Empty")
	used = true
	
func body_entered(body):
	if party.size() == 1 && body == party[0].active_player && !used:
		body.interact_areas.append(self)

func body_exit(body):
	if party.size() == 1 && body == party[0].active_player:
			if self in body.interact_areas:
				body.interact_areas.erase(self)
		
func save():
	if(persistence_id != ""):
		return {
			"persistence_id" : persistence_id,
			"used" : used
		}
	else:
		return {}
	
func on_load():
	if used:
		animations.play("Empty")
		interact_area.disconnect("body_entered", self, "body_entered")
		interact_area.disconnect("body_exited", self, "body_exit")
		emit_signal("used")
