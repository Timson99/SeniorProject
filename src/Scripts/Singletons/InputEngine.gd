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

var input_translator : Dictionary = {}

var input_recievers : Array = []

var input_disabled : bool = false

var directional_action


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("goto_called", self, "disable_input")
	SceneManager.connect("scene_fully_loaded", self, "enable_input")

func disable_input():
	input_disabled = true
	
func enable_input():
	input_disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input_recievers = get_tree().get_nodes_in_group("Persistent") if !input_disabled else []
	if input_recievers.size() == 0: 
		return
		
	if input_recievers[0] is Sprite:
		input_translator = to_player_commands
		
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
			input_recievers[0].call_deferred(command)
	

