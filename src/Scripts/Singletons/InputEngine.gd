extends Node

var to_player_commands := {
	"pressed": 
		{"ui_up" : "move_up",
		"ui_down" : "move_down",
		"ui_left" : "move_left",
		"ui_right" : "move_right"
		},
	"just_pressed": 
		{"ui_up" : "up_just_pressed",
		 "ui_accept" : "interact",
		 "ui_cancel" : "change_scene",
		 #Test Command
		"ui_test1" : "test_command1",
		"ui_test2" : "test_command2",
		"ui_test3" : "test_command3",
		"ui_test4" : "save_game",
		},
	"just_released": 
		{"ui_down" : "down_just_released",
		},
}

var to_dialogue_commands : Dictionary = {
	"pressed": {},
	"just_pressed": 
		{
		 "ui_accept" : "ui_accept_pressed",
		 "ui_cancel" : "ui_accept_pressed",
		},
	"just_released": {},
}

var to_battle_commands : Dictionary = {
	"pressed": {},
	"just_pressed": {
		"ui_test1" : "test_command1",
					},
	"just_released": {},
}

var valid_receivers := {
	"Debug_Menu" : {"priority": 1, "loop": "_process", "translator" : to_player_commands},
	"Battle_Menu" : {"priority": 2, "loop": "_process", "translator" : to_battle_commands},
	"Dialogue" : {"priority": 3, "loop": "_process", "translator" : to_dialogue_commands},
	"Menu" : {"priority": 4, "loop": "_process", "translator" : to_player_commands},
	"Player" : {"priority": 5, "loop": "_physics_process", "translator" : to_player_commands},
	"Test_Item" : {"priority": 6, "loop": "_process", "translator" : to_player_commands},
}

var input_disabled := false
var input_target = null
var prev_input_target = null
const group_name := "Input_Receiver"
var curr_input_receivers = []

var disabled = []




# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("goto_called", self, "disable_input")
	SceneManager.connect("scene_fully_loaded", self, "enable_input")
	
	
func update_and_sort_receivers():
	curr_input_receivers = get_tree().get_nodes_in_group(group_name)
	if curr_input_receivers.size() > 1: 
		curr_input_receivers.sort_custom(self, "sort_input_receivers")
	
	
func activate_receiver(node):
	if("input_id" in node and node.input_id in valid_receivers.keys()):
		node.add_to_group(group_name)
		update_and_sort_receivers()
	else: 
		Debugger.dprint("Unable to register %s, not a Valid Input Receiver" % node.name)

func deactivate_receiver(node):
	node.remove_from_group(group_name)
	update_and_sort_receivers()
	

func disable_input():
	input_disabled = true
	curr_input_receivers = []
	
func enable_input():
	input_disabled = false
	
func disable_player_input():
	disabled.append("Player")
	
func enable_all():
	disabled = []
	
	
func _process(_delta):
	process_input("_process")
	
	####Fullscreen Toggle for Testing###############
	if(Input.is_action_just_pressed("ui_fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen
	################################################


func _physics_process(_delta):
	process_input("_physics_process")
	
	
func sort_input_receivers(a,b):
	if (valid_receivers[a.input_id]["priority"] < valid_receivers[b.input_id]["priority"]):
		return true
	return false
	
	
func process_input(loop):
	var input_receivers = curr_input_receivers
	if input_receivers.size() == 0: 
		return
		
	input_target = input_receivers[0]
		 
	if input_disabled || input_target.input_id in disabled:
		return
	
	#Input Frame Delay prevents multiple inputs from two different sources when input target changes
	if input_target != prev_input_target and prev_input_target != null:
		prev_input_target = null
		return
	else:
		prev_input_target = input_target
		
	if valid_receivers[input_target.input_id]["loop"] == loop:
		translate_and_execute(valid_receivers[input_target.input_id]["translator"])
	
			
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
			if input_target.has_method(command):
				input_target.call_deferred(command)

