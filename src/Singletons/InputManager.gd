"""
	Input Manager

	
"""


extends Node


# Whether or no Input Manager is forwarding input to input_reciever
var frozen := false
# Current input target at the top of the input stack
var input_target = null
#Input Receiver the previous frame
var prev_input_target = null

# Input Node properties
var id_property_name = "input_id"
var input_data_property_name = "input_data"
# Registery of currently activate input receivers
# Operates as an Input Stack
var registry := NodeRegistry.new(id_property_name)

# Nodes that request to recieve callbacks from the current input reciever
var interceptors = {} # Id of itercepted node : intercepting node
# List of nodes ids that are disabled in place within their stack
var disabled = []


########
#	Callbacks
########

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SceneManager.connect("goto_called", self, "freeze")
	SceneManager.connect("scene_fully_loaded", self, "unfreeze")


func _process(_delta):
	_process_input("_process")
	
	####Fullscreen Toggle for Testing###############
	if(Input.is_action_just_pressed("ui_fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen
	################################################
	########Escape Toggle for Testing###############
	if(Input.is_action_just_pressed("ui_quit")):
		get_tree().quit()
	################################################


func _physics_process(_delta):
	_process_input("_physics_process")
	
	
########
#	Public
########
	
# Freezes input for current input nodes
func freeze():
	frozen = true

# Unfreezes input for current input nodes
func unfreeze():
	frozen = false
	
# Disable input for specific input node by id (stays at top of stack, but not called to)
func disable(input_id : String):
	disabled.append(input_id)

# Enables input for specific input node by id
func enable(input_id : String):
	disabled.erase(input_id)
	
# Enables all disabled nodes
func enable_all():
	disabled = []
	
"""
	A INPUT NODE may be activated and recieve input
	To register as a INPUT NODE, it must:
	1) Call InputManager.activate(self)
	2) Have an input_id property
	3) Have an input_data dictionary with:
		-A "loop" key to string that is _physics_process or _process 
			(Specifies when callbacks should be called)
		-Keys "just pressed", "just_released", and  "pressed" to dictionaries that
			map valid InputMap actions to function names in the node to call back to
		Example:	
					const input_data := {
						"loop": "_physics_process",
						"pressed": {
							"ui_up" : "move_up",
							...
						},
						"just_pressed": { ... }.
						"just_released": { ... },
					}
			
	Valid InputMap actions are strings found in the InputMap
		- If a dirctional input is used, it's callback will activate if 
		<action_name> or or <action_name>_axis is detected 
		(Ex, ui_left callback is called if ui_left or ui_left_axis is detected by Input )
		- Inputs may be combine with a '+' to trigger call_back only if both are detected
		(ui_left+ui_accept).  
"""

# Activates a InputNode, which will grab the input focus
func activate(node):
	if !(id_property_name in node):
		Debugger.dprint("ERROR REGISTERING INPUT NODE - No '%s' property" % id_property_name)
		return
	if node.get(id_property_name) == "":
		Debugger.dprint("ERROR REGISTERING INPUT NODE - EMPTY STRING ID")
		return
	if !(input_data_property_name in node):
		Debugger.dprint("ERROR REGISTERING INPUT NODE - No '%s' property" % 
						input_data_property_name)
		return
	if !node.get(input_data_property_name).has_all(["loop","just_pressed", "just_released", "pressed"]):
		Debugger.dprint("""ERROR REGISTERING INPUT NODE - Improperly Formatted %s :
						\tMust contain keys loop, just_pressed, just_released, and pressed
						\tThey keys must all have dictionary values""" % input_data_property_name)
		return
	registry.register(node)
	
# Deactivates InputNode, shifting focus to last input reciever to have focus
func deactivate(node):
	registry.deregister(node)


########
#	Private
########

# Picks which input_reciever will be given input
func _process_input(loop):
	var input_receiver_stack = registry.nodes
	if input_receiver_stack.size() == 0: 
		return
		
	# Fetches top of the Stack
	input_target = input_receiver_stack.back()

	if frozen || input_target == null || input_target.get(id_property_name) in disabled:
		return
	
	#Input Frame Delay prevents multiple inputs from two different sources when input target changes
	if input_target != prev_input_target and prev_input_target != null:
		prev_input_target = null
		return
	else:
		prev_input_target = input_target
		
	var input_translator = input_target.get(input_data_property_name)
	if input_translator["loop"] == loop:
		_translate_and_execute(input_translator)
	
# Executes callbacks for each actions in the input translator
func _translate_and_execute(input_translator):
	var commands = []
	for action in input_translator["just_pressed"].keys():
		if(_is_action_just_pressed(action)):
			commands.append(input_translator["just_pressed"][action])

	for action in input_translator["just_released"].keys():
		if(_is_action_just_released(action)):
			commands.append(input_translator["just_released"][action])

	for action in input_translator["pressed"].keys():
		if(_is_action_pressed(action)):
			commands.append(input_translator["pressed"][action])

	for command in commands:
		if input_target.has_method(command):
			input_target.call_deferred(command)
		else:
			Debugger.dprint(
				"WARNING INPUT MANAGER -> Callback '%s' does not exist in node with id '%s'" 
				% [command,input_target.get(id_property_name)])
			

#######
# 	Input Detection Overrides
#		-Fixes bug when mapping Joystick/Button to the same action
#		-Add simultaneous action functionality 
#######

func _is_action_just_pressed(action):
	return _multiaction_detected_just_pressed_final_action(action)
	
func _is_action_just_released(action):
	return _multiaction_detected_just_released_first_action(action)
	
func _is_action_pressed(action):
	return _multiaction_detected(action, "is_action_pressed")
	
# Fixes Joystick, allowing joystick and button directional input to be mapped
#	to the same action.
# Example -> ui_left has button input, ui_left_axis has joystick input
#	When ui_left is checked, ui_left and ui_left_axis will both be checked
func _action_detected(action : String, action_type : String) -> bool:
	var action_detected = Input.call(action_type, action)
	var axis_action_detected = ( 
		action in ["ui_left","ui_right","ui_up","ui_down"] && 
		Input.call(action_type, action + "_axis") 
	)
	return action_detected || axis_action_detected
	
# Multaction for just pressed -> Triggers frame that the final button in the sequence is just pressed
# Example - ui_left+ui_right 
func _multiaction_detected_just_pressed_final_action(action : String):
	var actions = action.split("+")
	var final_action_just_pressed = false
	for action in actions:
		var just_pressed_action = _action_detected(action, "is_action_just_pressed")
		var pressed_action = _action_detected(action, "is_action_pressed")
		if just_pressed_action:
			final_action_just_pressed = true	
		if !pressed_action:
			return false
	return final_action_just_pressed
	
# Multaction for just released -> Triggers frame that the first button in the sequence is just released
# Example - ui_left+ui_right 
func _multiaction_detected_just_released_first_action(action : String):
	if OS.get_ticks_msec() < 1: #All inputs are just released the first frame
		return false
	var actions = action.split("+")
	var first_action_just_released = false
	for action in actions:
		var just_released_action = _action_detected(action, "is_action_just_released")
		var unpressed_action = !_action_detected(action, "is_action_pressed")
		if just_released_action:
			first_action_just_released = true	
		if unpressed_action && !just_released_action:
			return false
	return first_action_just_released
	
# Strict multiaction on triggers if all buttons are just_released/just_pressed/pressed the same frame
func _multiaction_detected(action : String, action_type : String):
	var actions = action.split("+")
	for action in actions:
		var pressed_action = _action_detected(action, action_type)
		if !pressed_action:
			return false
	return true
	
