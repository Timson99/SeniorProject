extends Node2D

var active_player = null
var party : Array = []
var incapacitated : Array = []
var items = null
var spacing : float = 16
var persistence_id = "main_party"


func sort_characters(a,b):
	if int(a.name.substr(1,1)) < int(b.name.substr(1,1)):
		return true
	return false
	
	
func sort_alive(a,_b):
	if !a.alive:
		return false
	return true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	party = $YSort.get_children()
	party.sort_custom(self, "sort_alive")
	party.sort_custom(self, "sort_characters")
	if(party[0].alive == false):
		print("Game Over")
	else:
		if active_player != null:
			active_player.deactivate_player()
		party[0].activate_player()
		active_player = party[0]
		
		for i in range(party.size()):
			if(party[i].alive):
				party[i].set("party_data", {"active": active_player, 
											"num": i, 
											"party": party, 
											"spacing" : spacing,
											"sequence_formation": "following"
											})
				
func reposition(new_position : Vector2, new_direction):
	position.x = new_position.x
	position.y = new_position.y
	active_player.current_dir = new_direction
	for i in range(party.size()):
		party[i].position = Vector2(0,0)
		party[i].current_dir = new_direction
	
func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position, 
	}	
	return save_dict
	


