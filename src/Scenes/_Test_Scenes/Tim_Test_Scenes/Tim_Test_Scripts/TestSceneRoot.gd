extends Node

class_name Explore_Root


onready var party_group := get_tree().get_nodes_in_group("Party")
var party = null


func _ready():
	
	#CameraManager.set_scene_boundaries(63, 393, 23, 273)
	
	if party_group.size() != 1:
		print("ERROR: NO PARTY IN EXPLORE SCENE")
	else:
		party = party_group[0]
	pass



	
	
