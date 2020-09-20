extends Node

# member variables
export var speakerID = "setMe!"
export var queuedMsg = "none"
onready var interactable = get_node("Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	interactable.connect("pressed", self, "_interacts")

# Call the Dialogue Manager using the SpeakerID
func _interacts():
	print("SpeakerID: " + speakerID)
	get_node("../DialogueEngine")._beginTransmit(speakerID)
