extends Control

var turn = null 


onready var character_party = $BattleModules/Party_Modules
onready var enemy_party = $EnemyParty
onready var dialogue_node = $BattleDialogue/BattleDialogueBox
onready var characters = character_party.get_children()
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
	
	for c in characters:
		var move = yield(c, "move")
		moves_made.append(move)
		print("%s : %s" % [c.name, move.move_data])
		dialogue_node.display_message("%s : %s" % [c.name, move.move_data])
		
		#move = yield(UI, character.move_made_signal)
		#Add as queued character action
		
	for e in enemies:
		var move = e.make_move()
		moves_made.append(move)
		print("%s : %s" % [e.screen_name, move.move_data])
		dialogue_node.display_message("%s : %s" % [e.screen_name, move.move_data])
	
	print(moves_made)
	execute(moves_made)
	turn = null
	
	
func sort_by_speed(a,b):
	var a_speed = a.get_move()["Agent"].temp_battle_stats.get_stats()["SPEED"]
	var b_speed = b.get_move()["Agent"].temp_battle_stats.get_stats()["SPEED"]
	if a_speed >= b_speed:
		return true
	return false
	
func execute(moves_made : Array):
	moves_made.sort_custom(self, "sort_by_speed")
	for move in moves_made:
		var attack = move.get_move()["Agent"].stats.get_stats()["ATTACK"]
		if move.get_move()["Target"]:
			move.get_move()["Target"].take_damage(int(attack) * 3)
			print(attack)
			print(move.get_move()["Target"].stats.get_stats()["HP"])
	
	
	
	
	
	
