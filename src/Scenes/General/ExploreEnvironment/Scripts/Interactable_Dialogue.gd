extends Node

# member variables
export var speakerID = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exit")
	
func interact():
	DialogueEngine._beginTransmit(speakerID, "")

func body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player && speakerID != "":
		body.interact_areas.append(self)

func body_exit(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
			if self in body.interact_areas:
				body.interact_areas.erase(self)
