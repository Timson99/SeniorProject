extends Control

onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var menu = dialogue_node.get_node("Menu")
onready var enemies = enemy_party.enemies
var characters = null
var character_move_dict := {}

func _ready():
	turn()
	
func turn():
	yield(battle_engine(), "completed")
	turn()
		
		
func add_move(screen_name : String, move: BattleMove):
	character_move_dict[screen_name] = move
	
	
func remove_move(screen_name : String):
	character_move_dict.erase(screen_name)
	
func battle_engine():
	character_move_dict = {}
	characters = character_party.get_children()
	yield(get_tree().create_timer(0.5, false), "timeout")
	character_party.begin_turn()
	
	var moves_made := []
	yield(character_party, "all_moves_chosen")	
	moves_made = character_move_dict.values()
	menu.hide()
		
	for e in enemies:
		var move = e.make_move()
		moves_made.append(move)
		#print("%s : %s" % [e.screen_name, move.to_dict()])
		#dialogue_node.display_message("%s : %s" % [e.screen_name, move.to_dict()])

	yield(execute(moves_made), "completed")
	
	
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
		if !move.agent.alive || (move.target && !move.target.alive):
			continue
		
		
		dialogue_node.display_message(move.to_string(), false, 0.02, 2)
		yield(dialogue_node, "page_complete")
		
		if move.type == "Defend":
			move.agent.defending = true
			
			
		elif move.type == "Run":
			pass
			
			
		elif move.type == "Items":
			pass
			
			
		elif move.type == "Skills":
			
			
			var agent_attack = move.agent.stats.ATTACK
			var agent_willpower = move.agent.stats.WILLPOWER
			var agent_luck = move.agent.stats.LUCK
			
			var target_defense = move.target.stats.DEFENSE
			var target_willpower = move.target.stats.WILLPOWER
			var target_luck = move.target.stats.LUCK
			
			
			var base_damage = move.agent.stats.ATTACK * 1.5 * (move.skill_ref["Power"] + 1)
			var attack_variation = rand_range(0.75, 1.25)
			var damage = max(0, int(base_damage) * attack_variation)
			print("Agent Attack: %d, Target Defence %d, Variation %d" %
			 [agent_attack, target_defense, attack_variation])		
						
			randomize()
			var hit = true if randf() < move.skill_ref["Hit_Rate"] else false
			if hit:
				damage = int(damage/2 if move.target.defending else damage )
				yield(move.target.take_damage(int(damage)), "completed")
			else:
				dialogue_node.display_message("Miss", false, 0.02, 2)
				yield(dialogue_node, "page_complete")
				yield(get_tree().create_timer(1, false), "timeout")
		
		
		
		elif move.type == "Attack":
			
			
			
			var agent_attack = move.agent.stats.ATTACK
			var agent_willpower = move.agent.stats.WILLPOWER
			var agent_luck = move.agent.stats.LUCK
			
			var target_defense = move.target.stats.DEFENSE
			var target_willpower = move.target.stats.WILLPOWER
			var target_luck = move.target.stats.LUCK
			
			var base_damage = agent_attack - target_defense 
			 
			randomize()
			var attack_variation = rand_range(0.75, 1.25)
			var damage = max(1, int(base_damage * attack_variation))
			
			#Defending Halves Damage from Attacks
			damage = int(damage/2 if move.target.defending else damage )
			print("Agent Attack: %d, Target Defence %d, Variation %d" % [agent_attack, target_defense, attack_variation])
			
			yield(move.target.take_damage(int(damage * 100)), "completed")
			
		yield(get_tree().create_timer(0.1, false), "timeout")
		
		
	dialogue_node.clear()
	enemy_party.end_turn()
	character_party.end_turn()
	

			
func battle_victory():
	character_party.terminate_input()
	dialogue_node.display_message(["You Win!", "X Exp Earned."], true, 0.1, 1)
	yield(dialogue_node, "end")
	SceneManager.goto_saved()
	
func battle_failure():
	dialogue_node.display_message("You Lose!", false, 0.1, 1)
	SceneManager.goto_scene("GameOver")
	
	
	
	
	
	
