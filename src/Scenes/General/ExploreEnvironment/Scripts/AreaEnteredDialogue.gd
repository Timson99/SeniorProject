extends Area2D

# member variables
export var message = ""

#enum Mode {Outside, Inside, InsideTriggered}
#var mode = Mode.Outside

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exit")
	
func interact():
	DialogueManager.transmit_message(message)

func body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		interact()

