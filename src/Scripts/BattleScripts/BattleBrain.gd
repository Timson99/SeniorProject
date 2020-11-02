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
	
	var moves_made = {}

	#var enemies = enemy_party.enemies
	
	for c in characters:
		var move = yield(c, "move")
		moves_made[c.persistence_id] = {"Entity": c, "move" : move}
		print("%s : %s" % [c.name, move.move_data])
		dialogue_node.display_message("%s : %s" % [c.name, move.move_data])
		#move = yield(UI, character.move_made_signal)
		#Add as queued character action
		
	for e in enemies:
		var move = "Defend"
		moves_made[e.screen_name] = {"Entity": e, "move" : move}
		print(e.screen_name + " : " + move)
		dialogue_node.display_message(e.screen_name + " : " + move)
	
	print(moves_made)
	
	#execute(moves)
	turn = null
	pass
