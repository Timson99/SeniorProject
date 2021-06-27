extends Node

class_name Explore_Root


onready var party_group := get_tree().get_nodes_in_group("Party")
var party = null


func _ready():
	
	#CameraManager.set_scene_boundaries(63, 393, 23, 273)
	
	var dialogue_dict = DialogueParser.parse(
		FileTools.file_to_string("res://Assets/Dialogue/Area01_NEW.res")
	)
	FileTools.data_to_json(dialogue_dict, "res://Assets/Dialogue/DebugParse.txt", true)
	var speaker_list = []
	for d_id in dialogue_dict.values():
		for context in d_id.values():
			for line in context:
				if line.has("speaker") and !speaker_list.has(line["speaker"]):
					speaker_list.push_back(line["speaker"])
	print(speaker_list)
					
	
	
	
	if party_group.size() != 1:
		print("ERROR: NO PARTY IN EXPLORE SCENE")
	else:
		party = party_group[0]
	pass



	
	
