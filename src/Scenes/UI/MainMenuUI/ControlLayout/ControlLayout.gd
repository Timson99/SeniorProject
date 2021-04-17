extends CanvasLayer

export var is_intro_screen := true
onready var dialogue_node = $CanvasLayer/Control
onready var input_type = InputEngine.get_input_event_type()

var submenu = null
var parent = null
var intro_layer = 0
var menu_layer = 3

func _ready():
	InputEngine.connect("control_scheme_gathered", self, "change_control_layout")
	change_control_layout()
	if parent:
		is_intro_screen = false
		adjust_margins(parent)
	elif is_intro_screen:
		yield(get_tree().create_timer(5.0, false), "timeout")
		DialogueEngine.custom_message("Please press 'Confirm' or 'Cancel' when you are ready to continue.")
		yield(DialogueEngine, "end")
		SceneManager.goto_scene("LoadScreen", "", false)


func change_control_layout():
	var mapping = InputEngine.get_control_mapping()
	var controls = InputEngine.get_current_controls()
	$TextureRect/ControlMenu/HBox/VBoxLeft/Accept.text = str("Confirm: ", join_input_strings(controls["Accept"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxLeft/Cancel.text = str("Cancel: ", join_input_strings(controls["Cancel"]), "")
	$TextureRect/ControlMenu/HBox/VBoxLeft/MoveUp.text = str("Up: ", join_input_strings(controls["Move Up"]), "")
	$TextureRect/ControlMenu/HBox/VBoxLeft/MoveLeft.text = str("Left: ", join_input_strings(controls["Move Left"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/OpenMenu.text = str("Open Menu: ", join_input_strings(controls["Open Menu"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/MoveDown.text = str("Down: ", join_input_strings(controls["Move Down"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/MoveRight.text = str("Right: ", join_input_strings(controls["Move Right"]), " ")
	$TextureRect/ControlMenu/HBox/VBoxRight/ToggleFullscreen.text = str("Fullscreen On/Off: ", join_input_strings(controls["Toggle Fullscreen"]), " ")


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


func up():
	if submenu && !is_intro_screen:
		submenu.up()
		
	
func down():
	if submenu && !is_intro_screen:
		submenu.down()
	else:
		pass

func left():
	if submenu && !is_intro_screen:
		submenu.left()
	else:
		pass
	
func right():
	if submenu && !is_intro_screen:
		submenu.right()
	else:
		pass
		
			
func accept():
	pass


func back():
	if !is_intro_screen:
		BgEngine.play_sound("MenuButtonReturn")		
		queue_free()
		
