extends Node

# member variables
export var speakerID = "setMe!"
export var acceptSignal = ""
var sendSignal = ""
onready var interactable = get_node("NPCRadius")
onready var signalInteractable = get_node("../NoNoZone/DetectionRadius")


# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("body_entered", self, "_NPC_body_entered")
	signalInteractable.connect("body_entered", self, "_set_reactive")

func _set_reactive(body):
	sendSignal = acceptSignal

# Call the Dialogue Manager using the SpeakerID
func interact():
	print("SpeakerID: " + speakerID)
	DialogueManager.transmit_dialogue(speakerID)

func _NPC_body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		body.interact_areas.append(self)

func _NPC_body_exit(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
			body.interact_areas.erase(self)
