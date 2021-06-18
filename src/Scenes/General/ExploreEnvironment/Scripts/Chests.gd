extends Node

# member variables
onready var animations = $AnimatedSprite
onready var interact_area = $Area2D
var party

export var save_id = "" 
export var item_id = ""
export var opened = false

# Called when the node enters the scene tree for the first time.
func _ready():
	interact_area.connect("body_entered", self, "body_entered")
	interact_area.connect("body_exited", self, "body_exit")
	party = ActorManager.get_party()
	SaveManager.register(self)
	
func interact():
	if !opened:
		animations.play("closed_to_open")
		BgEngine.play_sound("OpenBox")
		yield(animations, "animation_finished")
		animations.play("open")
		opened = true
		if(item_id != ""):
			BgEngine.play_jingle("ItemJingle")
			DialogueEngine.item_message(item_id)
			if party:
				party.items.append(item_id)

func body_entered(body):
	if party && body == party.active_player && !opened:
		body.interact_areas.append(self)

func body_exit(body):
	if party && body == party.active_player:
			if self in body.interact_areas:
				body.interact_areas.erase(self)
				
func save():
	return {
		"opened" : opened
	}

	
func on_load():
	if opened:
		animations.play("open")
		interact_area.disconnect("body_entered", self, "body_entered")
		interact_area.disconnect("body_exited", self, "body_exit")
