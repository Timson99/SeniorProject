extends Control

var turn = null 


onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var enemies = enemy_party.enemies
var characters = null
var character_move_dict := {}

signal execution_complete

func _process(delta):
	if turn != null && turn.is_valid():
		return
	else:
		turn = funcref(self, "battle_engine")
		turn.call_func()
		
func add_move(screen_name : String, move: BattleMove):
	character_move_dict[screen_name] = move
	
func remove_move(screen_name : String):
	pass
	
	
func battle_engine():
	character_move_dict = {}
	characters = character_party.get_children()
	yield(get_tree().create_timer(1, false), "timeout")
	character_party.begin_turn()
	
	var moves_made := []
	yield(character_party, "all_moves_chosen")	
	moves_made = character_move_dict.values()
		
	for e in enemies:
		var move = e.make_move()
		moves_made.append(move)
		#print("%s : %s" % [e.screen_name, move.to_dict()])
		#dialogue_node.display_message("%s : %s" % [e.screen_name, move.to_dict()])

	execute(moves_made)
	yield(self, "execution_complete")
	turn = null
	
	
func sort_by_speed(a,b):
	var a_speed = a.agent.stats.SPEED
	var b_speed = b.agent.stats.SPEED
	if a_speed >= b_speed:
		return true
	return false
	
func sort_defends(a,_b):
	if a.type != "Defend":
		return false
	return true
	
func execute(moves_made : Array):
	moves_made.sort_custom(self, "sort_by_speed")
	moves_made.sort_custom(self, "sort_defends")
	for move in moves_made:
		dialogue_node.display_message(move.to_string(), false, 0.02, 2)
		yield(dialogue_node, "page_complete")
		
		if move.type == "Defend":
			move.agent.defending = true
		elif move.type == "Run":
			#Run
			pass
		elif move.type == "Items":
			#Run 
			pass
		elif move.type == "Skills":
			var damage = (move.agent.stats.ATTACK * 
						(move.skill_ref["Power"] + 2))
			print(damage)
			randomize()
			var hit = true if randf() < move.skill_ref["Hit_Rate"] else false
			if hit:
				print(move.target.defending)
				damage = int(damage/2 if move.target.defending else damage )
				move.target.take_damage(int(damage))
				yield(move.target, "move_effects_completed")
			else:
				dialogue_node.display_message("Miss", false, 0.02, 2)
				yield(dialogue_node, "page_complete")
				yield(get_tree().create_timer(1, false), "timeout")
		
		elif move.type == "Attack":
			var damage = move.agent.stats.ATTACK
			damage = int(damage/2 if move.target.defending else damage )
			move.target.take_damage(int(damage) * 10)
			yield(move.target, "move_effects_completed")
			
		yield(get_tree().create_timer(0.1, false), "timeout")
	dialogue_node.clear()
	enemy_party.end_turn()
	character_party.end_turn()
	emit_signal("execution_complete")
	

			
func battle_victory():
	character_party.terminate_input()
	print("Battle Victory")
	dialogue_node.display_message(["You Win!", "X Exp Earned."], true, 0.1, 1)
	yield(dialogue_node, "end")
	SceneManager.goto_saved()
	
func battle_failure():
	SceneManager.goto_scene("GameOver")
	
	
	
	
	
	
