extends Node

class_name Explore_Root


onready var party_group := get_tree().get_nodes_in_group("Party")
var party = null


func _ready():
	
	#CameraManager.set_scene_boundaries(63, 393, 23, 273)
	var ndm = NewDialogueManager.new()
	ndm.parse("""
d_id = "123"

CONTEXT MAIN
	PLAYER
		Hello You
	Jenny 
		That's 
		  Sexual 
		   Harrasment
	OPTION
		You Are a Ho -> Path1  
		I love you -> Path2
	PLAYER
		GUESS I'LL DIE
	
CONTEXT PATH1
	Jenny
		I'm never talking to you again

CONTEXT PATH2
	Jenny
		I'm never talking to you again
	PLAYER
		You think you can get away from me?
""")
	
	if party_group.size() != 1:
		print("ERROR: NO PARTY IN EXPLORE SCENE")
	else:
		party = party_group[0]
	pass



	
	
