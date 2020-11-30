extends Node2D

export var actor_id := "Party"
#export var C1_in_party = true
export var C2_in_party = true
export var C3_in_party = true

var active_player = null
var party := []
var incapacitated := []
var items := ["Bomb","Bomb", "Crappy Spatula", "Leaf Bag", "Milk Carton", "Peach Iced Tea","Leaf Bag"]
var spacing := 16.0
var persistence_id := "main_party"
onready var tween = $Tween


func sort_characters(a,b):
	if int(a.name.substr(1,1)) < int(b.name.substr(1,1)):
		return true
	return false


func sort_alive(a,_b):
	if !a.alive:
		return false
	return true


func init_in_party(condition, character_scene, name):
	if(condition):
		var party_member = character_scene.instance()
		party_member.name = name
		$YSort.add_child(party_member)



# Called when the node enters the scene tree for the first time.
func on_load():

	if(!C2_in_party):
		$YSort.remove_child($YSort/C2)
	if(!C3_in_party):
		$YSort.remove_child($YSort/C3)

	party = $YSort.get_children()
	$YSort.move_child($YSort/C1, party.size() - 1)
	party.sort_custom(self, "sort_alive")
	party.sort_custom(self, "sort_characters")

	if(party.size() == 0 or party[0].alive == false):
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
	set_global_position(new_position)
	active_player.current_dir = new_direction
	for i in range(party.size()):
		party[i].position = Vector2(0,0)
		party[i].current_dir = new_direction
		
signal tween_pos_completed
func tween_pos(destination, duration):
	tween.interpolate_property(self, "position", null, destination, duration)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("tween_pos_completed")


func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position,
		#"C1_in_party" : C1_in_party,
		"C2_in_party" : C2_in_party,
		"C3_in_party" : C3_in_party,
		"items" : items,
	}
	return save_dict


func change_sequenced_follow_formation(formation: String):
	for i in range(party.size()):
		if party[i].alive:
			party[i].party_data["sequence_formation"] = formation
