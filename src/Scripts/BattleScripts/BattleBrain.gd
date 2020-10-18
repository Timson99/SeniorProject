extends Node

var turn = null

var input_id := "Battle_Menu" 


signal test_signal(action_taken)

onready var modules_node = $BattleUI/BattleModules/Modules
onready var dialogue_node = $BattleUI/BattleDialogue/BattleDialogueBox
onready var charatcer_party_node = $B_Party
onready var enemy_party_node = $Enemy_Party



func _ready():
	if "Battle_Brain" in charatcer_party_node:
		charatcer_party_node.Battle_Brain = self
	if "Enemy" in enemy_party_node:
		enemy_party_node.Battle_Brain = self

func test_command1():
	emit_signal("test_signal", "Attack")
	
	
func update_character_party():
	if !charatcer_party_node.C2_in_party:
			modules_node.get_node("C2_Module").hide()
	if !charatcer_party_node.C3_in_party:
			modules_node.get_node("C3_Module").hide()
			
func register_enemy_party(party):
	enemy_party_node = party
	
	
func _process(delta):
	if turn != null && turn.is_valid():
		return
	else:
		turn = funcref(self, "battle_engine")
		turn.call_func()
	
	
func battle_engine():
	
	var characters = ["C1", "C2", "C3"]
	var enemies = ["E1"]
	
	for c in characters:
		var move = yield(self, "test_signal")
		print(c + " : " + move)
		#move = yield(UI, character.move_made_signal)
		#Add as queued character action
		
	for e in enemies:
		var move = "Defend"
		print(e + " : " + move)
	
	#execute(moves)
	turn = null
	pass
