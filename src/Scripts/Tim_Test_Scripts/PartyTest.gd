extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var active_player = null


func sort_characters(a,b):
	if !a.alive:
		return false
	if int(a.name.substr(1,1)) <  int(b.name.substr(1,1)):
		return true
	return false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var party = $YSort.get_children()
	party.sort_custom(self, "sort_characters")
	if(party[0].alive == false):
		print("Game Over")
	else:
		party[0].activate_player()
		active_player = party[0]
		for i in range(party.size()):
			if(party[i].alive):
				party[i].set("party_data", {"active": active_player, "num": i})
	



