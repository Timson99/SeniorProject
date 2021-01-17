extends HBoxContainer

#Carry Overs
onready var battle_brain = SceneManager.current_scene

export var persistence_id := "main_party"
export var C2_in_party = false
export var C3_in_party = false
var items := ["Bomb", "Crappy Spatula", "Leaf Bag", "Milk Carton", "Peach Iced Tea"]
var terminated = false

var selected_material = preload("res://Resources/Shaders/Illumination.tres")


var party = null
var party_alive = null
var front_player = null
var active_player = null

func _ready():
	$C1_Module.connect("move", self, "switch_characters")
	$C2_Module.connect("move", self, "switch_characters")
	$C3_Module.connect("move", self, "switch_characters")


func check_alive():
	if terminated:
		return
	for c in party:
		if c.alive:
			return
	terminated = true
	battle_brain.battle_failure()

func terminate_input():
	active_player.deactivate_player()
	terminated = true

func switch_characters(_move):
	active_player.deactivate_player()

	yield(get_tree().create_timer(0.1, false), "timeout")
	for i in range(party.find(active_player) + 1 , party_alive.size()):
		if(!party_alive[i].alive):
			continue
		active_player = party_alive[i]
		active_player.activate_player()
		return
	#No more characters, Enemy Move
	active_player = front_player
	#yield(get_tree().create_timer(1, false), "timeout")
	##############################
	#active_player.activate_player()


func sort_characters(a,b):
	if int(a.name.substr(1,1)) < int(b.name.substr(1,1)):
		return true
	return false


func sort_alive(a,_b):
	if !a.alive:
		return false
	return true

func on_load():
	if(!C2_in_party):
		var ref = $C2_Module
		remove_child(ref)
		ref.queue_free()
	if(!C3_in_party):
		var ref = $C3_Module
		remove_child(ref)
		ref.queue_free()

	party = get_children()
	party.sort_custom(self, "sort_alive")
	party.sort_custom(self, "sort_characters")
	party_alive = party.duplicate()
	for i in range(len(party)):
		party[i].screen_name = party[i].get_node("UI/Name").text

	if(party.size() == 0 or party[0].alive == false):
		print("Game Over")
	else:
		if front_player != null:
			active_player.deactivate_player()
		front_player = party[0]
		active_player = front_player

		for i in range(party.size()):
			if(party[i].alive):
				party[i].set("party", self)

func begin_turn():
	if !terminated:
		active_player.activate_player()


func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"items" : items,
	}
	return save_dict


####Character Selection
#################

var selected_module_index = -1

func select_current():
	active_player.select()
	selected_module_index = party.find(active_player)
	
func deselect_current():
	party[selected_module_index].deselect()
	selected_module_index = -1

func select_right():
	if(party_alive.size() <= 1):
		return
	party[selected_module_index].deselect()
	selected_module_index += 1
	selected_module_index = min(selected_module_index, party_alive.size() - 1)
	party[selected_module_index].select()

func select_left():
	if(party_alive.size() <= 1):
		return
	party[selected_module_index].deselect()
	selected_module_index -= 1
	selected_module_index = max(selected_module_index, 0)
	party[selected_module_index].select()


func get_selected_character():
	return party[selected_module_index]

func get_selected_character_name():
	return party[selected_module_index].screen_name

#######################################
