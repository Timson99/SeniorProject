extends Control

export var is_intro_screen := true
onready var dialogue_node = $CanvasLayer/Control
onready var input_type = InputEngine.get_input_event_type()

func _ready():
	InputEngine.connect("control_scheme_gathered", self, "change_control_layout")
	change_control_layout()
	if is_intro_screen:
		yield(get_tree().create_timer(5.0, false), "timeout")
		DialogueEngine.custom_message("Please press 'Confirm' when you are ready to continue.")
		yield(DialogueEngine, "end")
		# Go to next scene as desired (SaveLoad, opening title? Whichever makes most sense)
		SceneManager.goto_scene("LoadScreen", "", false)


func change_control_layout():
	var mapping = InputEngine.get_control_mapping()
	var controls = InputEngine.get_current_controls()
	$ControlMenu/HBox/VBoxLeft/Accept.text = str("Confirm: ", join_input_strings(controls["Accept"]), " ")
	$ControlMenu/HBox/VBoxLeft/Cancel.text = str("Cancel: ", join_input_strings(controls["Cancel"]), "")
	$ControlMenu/HBox/VBoxLeft/MoveUp.text = str("Up: ", join_input_strings(controls["Move Up"]), "")
	$ControlMenu/HBox/VBoxLeft/MoveLeft.text = str("Left: ", join_input_strings(controls["Move Left"]), " ")
	$ControlMenu/HBox/VBoxRight/OpenMenu.text = str("Open Menu: ", join_input_strings(controls["Open Menu"]), " ")
	$ControlMenu/HBox/VBoxRight/MoveDown.text = str("Down: ", join_input_strings(controls["Move Down"]), " ")
	$ControlMenu/HBox/VBoxRight/MoveRight.text = str("Right: ", join_input_strings(controls["Move Right"]), " ")
	$ControlMenu/HBox/VBoxRight/ToggleFullscreen.text = str("Fullscreen On/Off: ", join_input_strings(controls["Toggle Fullscreen"]), " ")


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
