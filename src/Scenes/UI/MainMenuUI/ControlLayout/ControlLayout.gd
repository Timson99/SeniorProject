""""
extends CanvasLayer

export var is_intro_screen := true
onready var dialogue_node = $CanvasLayer/Control
onready var remapping_text = $TextureRect/ControlMenu/RemappingText.text
onready var input_type = InputManager.get_input_event_type()

var submenu = null
var parent = null
var intro_layer = 0
var menu_layer = 3
var uic = null
var remapping = false
var correct_input = true
var confirm_cancel = -1

signal remapping_complete()

func _ready():
	InputManager.connect("control_scheme_gathered", self, "change_control_layout")
	change_control_layout()
	if parent:
		is_intro_screen = false
		adjust_margins(parent)
	elif is_intro_screen:
		$TextureRect/ControlMenu/RemappingText.visible = false
		yield(get_tree().create_timer(5.0, false), "timeout")
		DialogueEngine.custom_message("Please press 'Confirm' or 'Cancel' when you are ready to continue.")
		yield(DialogueEngine, "end")
		SceneManager.goto_scene("LoadScreen", "", false)


func change_control_layout():
	var mapping = InputManager.get_control_mapping()
	var controls = InputManager.get_current_controls() 
	$TextureRect/ControlMenu/HBox/VBoxLeft/Accept.text = str("Confirm: ", join_input_strings(controls["Accept"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxLeft/Cancel.text = str("Cancel: ", join_input_strings(controls["Cancel"]), "")
	$TextureRect/ControlMenu/HBox/VBoxLeft/MoveUp.text = str("Up: ", join_input_strings(controls["Move Up"]), "")
	$TextureRect/ControlMenu/HBox/VBoxLeft/MoveLeft.text = str("Left: ", join_input_strings(controls["Move Left"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/OpenMenu.text = str("Open Menu: ", join_input_strings(controls["Open Menu"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/MoveDown.text = str("Down: ", join_input_strings(controls["Move Down"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/MoveRight.text = str("Right: ", join_input_strings(controls["Move Right"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/ToggleFullscreen.text = str("Fullscreen On/Off: ", join_input_strings(controls["Fullscreen On/Off"]), " ")


func adjust_margins(parent: Node):
	var parent_layer = parent.get_node("TextureRect")
	$TextureRect.margin_left = parent_layer.margin_left
	$TextureRect.margin_top = parent_layer.margin_top
	$TextureRect.margin_right = parent_layer.margin_right
	$TextureRect.margin_bottom = parent_layer.margin_bottom


func get_readable_input(event):
	if event is InputEventJoypadButton:
		var joypad_input = Input.get_joy_button_string(event.get_button_index())
		if "Face Button" in joypad_input:
			joypad_input = joypad_input.replace("Face Button", "")
			joypad_input = str(joypad_input, " BTN")
		return joypad_input.strip_edges()
	else:
		return OS.get_scancode_string(event.get_scancode_with_modifiers())


func join_input_strings(inputs: Array):
	if inputs.size() == 1:
		return get_readable_input(inputs[0])
	var joined_string := ""	
	for input in inputs:
		var string_input = get_readable_input(input)
		if input == inputs[0]:
			joined_string = str(string_input)
		else:
			joined_string = str(joined_string, ", ", string_input)
	return joined_string

	
func remap_button(ui_control: String):
	var command_to_remap = InputManager.get_control_mapping()[ui_control]
	uic = ui_control
	$TextureRect/ControlMenu/RemappingText.text = "Press the new button to map to %s:" % command_to_remap
	remapping = true
	yield(self, "remapping_complete")
	remapping = !remapping
	change_control_layout()
	$TextureRect/ControlMenu/RemappingText.text = "New button mapped! Escape this submenu or remap another button."
	yield(get_tree().create_timer(1.0, false), "timeout")
	$TextureRect/ControlMenu/RemappingText.text = remapping_text
	
	
func remap(event: InputEvent):
	if event is InputEventJoypadButton:
		_modify_mapped_inputs(event, InputEventJoypadButton)
	elif event is InputEventKey:
		_modify_mapped_inputs(event, InputEventKey)
	yield(get_tree().create_timer(1.0, false), "timeout")


func _modify_mapped_inputs(new_input: InputEvent, input_type):
	var prev_mapped_action = null
	var all_actions = InputMap.get_actions()
	for action in all_actions:
		if InputMap.event_is_action(new_input, action):
			prev_mapped_action = action 
	if prev_mapped_action:
		var uic_action_list = InputMap.get_action_list(uic)
		InputMap.action_add_event(prev_mapped_action, uic_action_list[0])
		InputMap.action_erase_event(prev_mapped_action, new_input)
	for input in InputMap.get_action_list(uic):
		if input is input_type:
			InputMap.action_erase_event(uic, input)
		InputMap.action_add_event(uic, new_input)
	InputManager.define_control_inputs(input_type)
	uic = null
	return


func _input(event):
	if remapping:
		correct_input = !correct_input
		if correct_input:
			remap(event)
			correct_input = true
			emit_signal("remapping_complete")
	

func up():
	if !is_intro_screen:
		remap_button("ui_up")
	
func down():
	if !is_intro_screen:
		remap_button("ui_down")
		
				
func left():
	if !is_intro_screen:
		remap_button("ui_left")
	
func right():
	if !is_intro_screen:
		remap_button("ui_right")
		
			
func accept():
	if !is_intro_screen:
		if confirm_cancel == -1:
			remap_button("ui_accept")
		elif confirm_cancel == 0:
			remap_button("ui_cancel")
		confirm_cancel = -1


func back():
	if !is_intro_screen:
		confirm_cancel +=1
		$TextureRect/ControlMenu/RemappingText.text = "Press Cancel again to exit submenu; otherwise, press Confirm to remap Cancel command."
		if confirm_cancel == 0:
			return
		AudioManager.play_sound("MenuButtonReturn")		
		queue_free()
		
		
func open_menu():
	if !is_intro_screen:
		remap_button("ui_menu")
"""
