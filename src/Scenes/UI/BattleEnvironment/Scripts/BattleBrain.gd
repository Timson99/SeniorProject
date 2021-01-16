extends Control

var turn = null 


onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var enemies = enemy_party.enemies
onready var characters = character_party.get_children()

signal execution_complete

func _process(delta):
	if turn != null && turn.is_valid():
		return
	else:
		turn = funcref(self, "battle_engine")
		turn.call_func()
	
func battle_engine():
	yield(get_tree().create_timer(1, false), "timeout")
	character_party.begin_turn()
	
	var moves_made := []

	#var enemies = enemy_party.enemies

	for i in range(0, characters.size()):
		var c = characters[i]
		var move = yield(c, "move")
		moves_made.append(move)
		print("%s : %s" % [c.name, move.to_dict()])
		#dialogue_node.display_message("%s : %s" % [c.name, move.to_dict()])
		print(characters)
		#Add as queued character action
	
		
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
	
func execute(moves_made : Array):
	moves_made.sort_custom(self, "sort_by_speed")
	for move in moves_made:
		dialogue_node.display_message(move.to_string(), false, 0.1, 1)
		yield(dialogue_node, "page_complete")
		
		var attack = move.agent.stats.ATTACK
		if move.target:
			move.target.take_damage(int(attack) * 10)
			yield(move.target, "move_effects_completed")
			#print(attack)
			#print(move.target.stats.HP)
			
		yield(get_tree().create_timer(0.1, false), "timeout")
	emit_signal("execution_complete")
			
func battle_victory():
	character_party.terminate_input()
	print("Battle Victory")
	dialogue_node.display_message(["You Win!", "X Exp Earned."], true, 0.1, 1)
	yield(dialogue_node, "end")
	SceneManager.goto_saved()
	
func battle_failure():
	pass
	
	
	
	
	
	
