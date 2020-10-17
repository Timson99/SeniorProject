extends Node


onready var MainScenes = preload("res://Scripts/Resource_Scripts/MainScenes.gd").new()
onready var active := false

var turn = null

var input_id := "Battle_Menu" 


signal test_signal(action_taken)


func _ready():
	SceneManager.connect("scene_fully_loaded", self, "change_state")
	change_state()
	
func change_state():
	if(SceneManager.current_scene.filename in MainScenes.battle_scenes.values()):
		active = true
		InputEngine.activate_receiver(self)
	else:
		active = false
		InputEngine.deactivate_receiver(self)
		
func test_command1():
	emit_signal("test_signal", "Attack")
	
	
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
