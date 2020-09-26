extends Node

var to_player_commands : Dictionary = {
	"pressed": 
		{"ui_accept" : "save_game",
		"ui_cancel" : "change_scene",
		"ui_up" : "move_up",
		"ui_down" : "move_down",
		"ui_left" : "move_left",
		"ui_right" : "move_right"},
	"just_pressed": 
		{"ui_up" : "up_just_pressed"},
	"just_released": 
		{"ui_down" : "down_just_released"},
}

var to_dialogue_commands : Dictionary = {}

var valid_recievers = {
	"Debug_Menu" : {"priority": 1, "loop": "_process", "translator" : to_player_commands},
	"Battle Menu" : {"priority": 2, "loop": "_process", "translator" : to_player_commands},
	"Dialogue" : {"priority": 3, "loop": "_process", "translator" : to_player_commands},
	"Menu" : {"priority": 4, "loop": "_process", "translator" : to_player_commands},
	"Player" : {"priority": 5, "loop": "_physics_process", "translator" : to_player_commands},
	"Test_Item" : {"priority": 6, "loop": "_process", "translator" : to_player_commands},
}

var input_disabled : bool = false
var input_target = null
var group_name = "Input_Reciever"



# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("goto_called", self, "disable_input")
	SceneManager.connect("scene_fully_loaded", self, "enable_input")

func disable_input():
	input_disabled = true
	
func enable_input():
	input_disabled = false

	
func _process(delta):
	process_input("_process")
		

func _physics_process(delta):
	process_input("_physics_process")
		
		
func process_input(loop):
	var input_recievers = get_tree().get_nodes_in_group(group_name) if !input_disabled else []
	if input_recievers.size() == 0: 
		return
	input_target = get_input_target(input_recievers)
	if input_target == null: 
		return	
	
	if valid_recievers[input_target.input_id]["loop"] == loop:
		translate_and_execute(valid_recievers[input_target.input_id]["translator"])
	
			
func translate_and_execute(input_translator):
	var commands = []
	for action in input_translator["just_pressed"].keys():
		if(Input.is_action_just_pressed(action)):
			commands.append(input_translator["just_pressed"][action])
			break
	for action in input_translator["just_released"].keys():
		if(Input.is_action_just_released(action)):
			commands.append(input_translator["just_released"][action])
			break
	for action in input_translator["pressed"].keys():
		if(Input.is_action_pressed(action)):
			commands.append(input_translator["pressed"][action])
			break
			
	for command in commands:
			input_target.call_deferred(command)
			
			
# Returns Input Reciever that gets priority, null if one does not exist
func get_input_target(input_recievers):
	var temp_input_target = null
	var current_priority = 100000
	for reciever in input_recievers:
		if not "input_id" in reciever:
			print("INPUT ENGINE ERROR: Input Reciever has no input_id")
		elif valid_recievers[reciever.input_id]["priority"] < current_priority:
			temp_input_target = reciever
			current_priority = valid_recievers[reciever.input_id]["priority"]
	return temp_input_target
	
