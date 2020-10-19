extends Control

var turn = null 


onready var character_party = $BattleUI/BattleModules/Party_Modules
onready var enemy_party = $BattleUI/BattleModules/EnemyParty
onready var dialogue_node = $BattleUI/BattleDialogue/BattleDialogueBox



func _ready():
	#PersistentData.connect("all_pdata_loaded", self, "initialize_ui")
	pass
	
func _process(delta):
	if turn != null && turn.is_valid():
		return
	else:
		turn = funcref(self, "battle_engine")
		turn.call_func()
	
func battle_engine():
	yield(get_tree().create_timer(0.2, false), "timeout")
	character_party.begin_turn()
	
	var moves_made = {}
	
	var characters = character_party.get_children()
	var enemies = ["E1"]
	
	for c in characters:
		var move = yield(c, "move")
		moves_made[c.name] = {"Entity": c, "move" : move}
		print("%s : %s" % [c.name, move])
		#move = yield(UI, character.move_made_signal)
		#Add as queued character action
		
	for e in enemies:
		var move = "Defend"
		moves_made["Enemy1"] = {"Entity": e, "move" : move}
		print(e + " : " + move)
	
	print(moves_made)
	
	#execute(moves)
	turn = null
	pass
