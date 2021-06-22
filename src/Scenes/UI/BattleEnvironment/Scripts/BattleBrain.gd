extends Control

onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var menu = dialogue_node.get_node("Menu")
onready var enemies = enemy_party.enemies
var characters = null
var character_move_dict := {}
var escaped = false
var attempted_escapes = 0
var fighting_boss = false

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
		
		var move_details = move.to_dict()	
		
		if move.type == "Defend":
			move.agent.defending = true
			
			dialogue_node.display_message("%s assumes a defensive stance." % move.agent.screen_name, false, 0.02, 2)
			yield(dialogue_node, "page_complete")
			
			
		elif move.type == "Run":
			
			dialogue_node.display_message("%s tries to run..." % move.agent.screen_name, false, 0.04, 2)
			yield(dialogue_node, "page_complete")
			
			if fighting_boss:
				dialogue_node.display_message("You can't run from this strong of an opponent!", true, 0.05, 1)
				yield(dialogue_node, "page_complete")
			else:
				escaped = calculate_escape_chance(move, enemies, moves_made)
				if escaped:
					AudioManager.play_sound("BasicPlayerFleeing")
					dialogue_node.display_message("...And the party safely skedaddled!", true, 0.05, 1)
					yield(dialogue_node, "end")
					break
				else:
					attempted_escapes += 1
					dialogue_node.display_message("Couldn't escape!", true, 0.01, 1)
					yield(dialogue_node, "page_complete")
			
		elif move.type == "Items":
			pass
			
			
		elif move.type == "Skills":
			
			dialogue_node.display_message("%s uses %s on %s!" % \
				[move.agent.screen_name, move.skill_id, move.target.screen_name], false, 0.02, 2)
			yield(dialogue_node, "page_complete")
			
			move.agent.stats.SP -= move.skill_cost
			
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
				dialogue_node.display_message("%s's special attack missed!" % move.agent.screen_name, false, 0.02, 2)
				yield(dialogue_node, "page_complete")
				yield(get_tree().create_timer(1, false), "timeout")
		
			print(damage)
			
		elif move.type == "Attack":
			
			dialogue_node.display_message("%s attacks %s!" % [move.agent.screen_name, move.target.screen_name], false, 0.02, 2)
			yield(dialogue_node, "page_complete")
			
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
		
	if escaped:
		battle_escape()
		
	dialogue_node.clear()
	enemy_party.end_turn()
	character_party.end_turn()
	
	
# Basic XP calculator ~ should likely be tweaked for game balance!	
func calculate_xp_payout(base_xp: int):
	var cumul_char_lvs := 0
	var cumul_enem_lvs := 0
	for character in characters:
		if !is_instance_valid(character):
			continue
		cumul_char_lvs += character.stats.to_dict()["LEVEL"]
	for enemy in enemies:
		cumul_enem_lvs += enemy.stats.to_dict()["LEVEL"]
	return floor(base_xp * pow(1.2, (cumul_enem_lvs - cumul_char_lvs)))
	
			
func battle_victory():
	character_party.terminate_input()
	AudioManager.play_battle_victory()
	var adjusted_xp_payout = calculate_xp_payout(enemy_party.xp_payout)
	dialogue_node.display_message(["You Win!", "%d Exp Earned." % adjusted_xp_payout], true, 0.1, 1)
	yield(dialogue_node, "end")
	for character in characters:
		if !is_instance_valid(character):
			continue
		"""
		Game.leveling.give_xp(id, adjusted_xp_payout)
		if Game.leveling.crossed_lv_xp_threshold(id):
			character.stats = Game.leveling.level_up(id)
			var char_name = character.screen_name
			var new_level = character.stats.to_dict()["LEVEL"]
			AudioManager.play_jingle("LevelUp")
			dialogue_node.display_message(["%s grew to level %d!" % [char_name, new_level]], true, 0.1, 1)
			yield(dialogue_node, "end")
		"""
	AudioManager.return_from_battle()
	SceneManager.goto_flagged()
	
func battle_failure():
	dialogue_node.display_message("You Lose!", false, 0.1, 1)
	SceneManager.goto_scene("GameOver")
	AudioManager.play_game_over()
	
	
func battle_escape():
	character_party.terminate_input()
	AudioManager.return_from_battle()
	SceneManager.goto_flagged()
	

func calculate_escape_chance(move: BattleMove, enemies: Array, moves_made: Array):
	var player_speed = move.agent.stats.SPEED 
	var max_enemy_speed = 0
	var summed_enemy_speed = 0
	
	for e in enemies:
		if "is_boss" in e.ai && e.ai.is_boss:
			fighting_boss = true
			return false
		var e_speed = e.stats.SPEED
		max_enemy_speed = max(max_enemy_speed, e_speed)
		summed_enemy_speed += e_speed
	fighting_boss = false
	
	if player_speed > max_enemy_speed:
		return true
	
	var escape_result = (player_speed > 
		(summed_enemy_speed / (characters.size() + 4.0 * attempted_escapes))) 	
	return escape_result	
