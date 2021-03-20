extends StaticBody2D

onready var animations = $AnimationPlayer
onready var interact_area = $Area2D
onready var party = get_tree().get_nodes_in_group("Party")
var used = false
var persistence_id = "Area01_Closet"

signal used


func _ready():
	pass
	
func interact():
	if (party.size() == 1 and
		party[0].active_player.has_method("change_skin") and
		party[0].active_player.persistence_id == "C1"):
		BgEngine.play_sound("PutOnCoat01")
		party[0].active_player.change_skin("default")
	make_closet_used()
	
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
		
func make_closet_used():
	animations.play("Empty")
	interact_area.disconnect("body_entered", self, "body_entered")
	interact_area.disconnect("body_exited", self, "body_exit")
	emit_signal("used")
	used = true
	
func make_closet_unused():
	animations.play("Full")
	interact_area.connect("body_entered", self, "body_entered")
	interact_area.connect("body_exited", self, "body_exit")
	used = false
	
func on_load():
	if used:
		make_closet_used()
	else:
		make_closet_unused()
