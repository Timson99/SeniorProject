extends Area2D

# member variables
export var event_key = ""
export var one_shot = true
export var persistence_id = ""
var triggered = false

#enum Mode {Outside, Inside, InsideTriggered}
#var mode = Mode.Outside

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Persistent")
	connect("body_entered", self, "body_entered")
	connect("body_exited", self, "body_exit")
	
func trigger_event():
	triggered = true
	if event_key != "":
		Sequencer.execute_event(event_key)

func body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		if !one_shot or !triggered:
			trigger_event()
		
func save():
	if persistence_id == "":
		Debugger.dprint("Invalid Trigger Persistance Id")
	else:
		return {
			"persistence_id" : persistence_id,
			"triggered" : triggered,
		}
		

