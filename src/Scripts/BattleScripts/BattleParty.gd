extends HBoxContainer

#Carry Overs
export var persistence_id := "main_party"
export var C2_in_party = false
export var C3_in_party = false
var items := []
var terminated = false


var party = null
var front_player = null
var active_player = null

func _ready():
	$C1_Module.connect("move", self, "switch_characters")
	$C2_Module.connect("move", self, "switch_characters")
	$C3_Module.connect("move", self, "switch_characters")



func terminate_input():
	active_player.deactivate_player()
	terminated = true

func switch_characters(_move):
	party = get_children()
	active_player.deactivate_player()
		
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	for i in range(party.find(active_player) + 1 , party.size()):
		if(!party[i].alive):
			continue
		active_player = party[i]
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
		$C2_Module.queue_free()
	if(!C3_in_party):
		$C3_Module.queue_free()	
	
	party = get_children()
	party.sort_custom(self, "sort_alive")
	party.sort_custom(self, "sort_characters")
	
	if(party.size() == 0 or party[0].alive == false):
		print("Game Over")
	else:
		if front_player != null:
			active_player.deactivate_player()
		front_player = party[0]
		active_player = front_player
		
		for i in range(party.size()):
			if(party[i].alive):
				party[i].set("party_data", {"items": items, 
											"party": party, 
											})
											
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
"""
func select_current():
	if enemies[selected_enemy_index].alive:
		enemies[selected_enemy_index].select()
	else:
		select_right()
	
func deselect_current():
	enemies[selected_enemy_index].deselect()
	selected_enemy_index = 0

func select_right():
	if(enemies.size() == 1):
		return
	enemies[selected_enemy_index].deselect()
	selected_enemy_index += 1
	selected_enemy_index = min(selected_enemy_index, enemies.size() - 1)

	if(!enemies[selected_enemy_index].alive):
		if(selected_enemy_index ==  enemies.size() - 1):
			select_left()
		else:
			select_right()

			
	
	enemies[selected_enemy_index].select()
	
func select_left():
	if(enemies.size() == 1):
		return
	enemies[selected_enemy_index].deselect()
	selected_enemy_index -= 1
	selected_enemy_index = max(selected_enemy_index, 0)

	if(!enemies[selected_enemy_index].alive):
		if(selected_enemy_index == 0):
			select_right()
		else:
			select_left()
	
	enemies[selected_enemy_index].select()
	
func select_up():
	if(enemies.size() == 1):
		return
	
func select_down():
	if(enemies.size() == 1):
		return
		
func get_selected_enemy():
	return enemies[selected_enemy_index]

func get_selected_enemy_name():
	return enemies[selected_enemy_index].screen_name
"""
