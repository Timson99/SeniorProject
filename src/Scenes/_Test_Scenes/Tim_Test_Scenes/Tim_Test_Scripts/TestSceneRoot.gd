extends Node

class_name Explore_Root


onready var party_group := get_tree().get_nodes_in_group("Party")
var party = null


func _ready():
	
	#CameraManager.set_scene_boundaries(63, 393, 23, 273)
	
	"""
	var dialogue_dict = DialogueParser.parse(
		FileTools.file_to_string("res://Assets/Dialogue/Area01_NEW.res")
	)
	FileTools.data_to_json(dialogue_dict, "res://Assets/Dialogue/DebugParse.txt", true)
	"""	

	if party_group.size() != 1:
		print("ERROR: NO PARTY IN EXPLORE SCENE")
	else:
		party = party_group[0]
	pass
	
func _process(delta):
	if ( Input.is_action_just_pressed("ui_accept") and 
		!DialogueManager.dialogue_box.is_visible_in_tree() ):
		DialogueManager.transmit_dialogue("Test1")



	
	
