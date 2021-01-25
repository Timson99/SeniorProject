extends HBoxContainer

#Carry Overs
onready var battle_brain = SceneManager.current_scene

export var persistence_id := "main_party"
export var C2_in_party = false
export var C3_in_party = false
export var items := ["Bomb", "Crappy Spatula", "Leaf Bag", "Milk Carton", "Peach Iced Tea"]
#export var items := []
var terminated = false

var selected_material = preload("res://Resources/Shaders/Illumination.tres")

signal all_moves_chosen

var party = null
var party_alive = null
var front_player = null
var active_player = null

func _ready():
	pass

func end_turn():
	for c in party:
		c.defending = false
	for c in party:
		if c.alive:
			active_player = c
			break

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


func move_and_switch(move : BattleMove):
	battle_brain.add_move(move.agent.screen_name, move)
	switch_characters()

func switch_characters():
	active_player.deactivate_player()
	
	yield(get_tree().create_timer(0.1, false), "timeout")
	for i in range(party_alive.find(active_player) + 1 , party_alive.size()):
		if(!party_alive[i].alive):
			continue
		active_player = party_alive[i]
		active_player.activate_player()
		return
	emit_signal("all_moves_chosen")
	#No more characters, Enemy Move


func cancel_previous_character_move():
	if party_alive.size() > 1 && active_player != party_alive[0]:
		active_player.deactivate_player()
		
		yield(get_tree().create_timer(0.1, false), "timeout")
		var previous_char_index = party_alive.find(active_player) - 1
		active_player = party_alive[previous_char_index]
		battle_brain.remove_move(active_player.screen_name)
		active_player.activate_player()
	return
	

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
		for c in party:
			if c.alive:
				active_player = c
				break
		for i in range(party.size()):
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
