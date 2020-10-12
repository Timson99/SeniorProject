extends Node

# member variables
export var speakerID = "setMe!"
export var queuedMsg = "none"
onready var interactable = get_node("NPCRadius")

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("body_entered", self, "_NPC_body_entered")

# Call the Dialogue Manager using the SpeakerID
func _interacts(body):
	print("SpeakerID: " + speakerID)
	get_node("../DialogueEngine")._beginTransmit(speakerID)

func _NPC_body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		body.interact_areas.append(speakerID)

func _NPC_body_exit(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
			body.interact_areas.erase(speakerID)
