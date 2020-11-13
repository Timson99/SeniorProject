extends Control

var turn = null 


onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var enemies = enemy_party.enemies


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
	var characters = character_party.get_children()
	for c in characters:
		var move = yield(c, "move")
		moves_made.append(move)
		print("%s : %s" % [c.name, move.to_dict()])
		dialogue_node.display_message("%s : %s" % [c.name, move.to_dict()])
		print(characters)
		#move = yield(UI, character.move_made_signal)
		#Add as queued character action
		
	print("End")
		
	for e in enemies:
		var move = e.make_move()
		moves_made.append(move)
		print("%s : %s" % [e.screen_name, move.to_dict()])
		#dialogue_node.display_message("%s : %s" % [e.screen_name, move.to_dict()])

	execute(moves_made)
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
		var attack = move.agent.stats.ATTACK
		if move.target:
			move.target.take_damage(int(attack) * 10)
			#print(attack)
			#print(move.target.stats.HP)
			
func battle_victory():
	print("Battle Victory")
	
func battle_failure():
	pass
	
	
	
	
	
	
