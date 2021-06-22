extends Control

var save_file_scene = preload("res://Scenes/General/SaveLoadMenu/SaveFile.tscn")
onready var button_container = $Control/VBoxContainer
onready var tween = $Tween

var save_files_num : int
var default_focused = 1
var focused = default_focused 
var buttons = []

var scroll_time = 0.15
var max_y = 32
var min_y : int

enum Mode {Load, Save}
export (Mode) var current_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	InputManager.activate(self)
	"""" For auto generation, shouldn't use since it makes UI tweaks difficult
	for file_name in save_file_names:
		var save_file = save_file_scene.instance()
		save_file.save_file_name = file_name
		button_container.add_child(save_file)
	"""
	
	buttons = button_container.get_children()
	save_files_num = buttons.size()
	min_y = max_y + ((save_files_num - 3) * (-64))
	
	var last_used_save_index = 0
	for i in range(0, buttons.size()):
		if buttons[i].save_file_name == SaveManager.last_used_save_file:
			last_used_save_index = i
		
	
	if current_mode == Mode.Save:
		focused = last_used_save_index + 1
		button_container.rect_position.y += max((-64 * (focused - 1)), min_y - max_y)
	buttons[focused-1].get_node("AnimatedSprite").animation = "on"
	
	
const input_data: Dictionary = {
	"loop": "_process",
	"pressed":{},
	"just_pressed": 
		{
		"ui_cancel": "back",
		"ui_accept": "accept",
		"ui_up": "up",
		"ui_down": "down",
		},
	"just_released": {},
}


func up():
	if tween.is_active():
		return
	var last_focused = focused
	focused -= 1
	focused = max(1, focused)
	if(focused > 2):
		var change =  min(button_container.rect_position.y+64,max_y)
		if (last_focused != focused):
			tween.interpolate_property(button_container, "rect_position:y", 
				button_container.rect_position.y, change, scroll_time)
			tween.start()
	buttons[last_focused-1].get_node("AnimatedSprite").animation = "off" 
	buttons[focused-1].get_node("AnimatedSprite").animation = "on"

func down():
	if tween.is_active():
		return
	var last_focused = focused
	focused += 1
	focused = min(save_files_num, focused)
	if(focused > 3):
		var change = max(button_container.rect_position.y-64,min_y)
		if (last_focused != focused):
			tween.interpolate_property(button_container, "rect_position:y", 
				button_container.rect_position.y, change, scroll_time)
			tween.start()
	buttons[last_focused-1].get_node("AnimatedSprite").animation = "off" 
	buttons[focused-1].get_node("AnimatedSprite").animation = "on" 
	
func accept():
	if tween.is_active():
		return
	if current_mode == Mode.Load:
		buttons[focused-1].accept_load()
	elif current_mode == Mode.Save:
		buttons[focused-1].accept_save()
		
func back():
	if current_mode == Mode.Save:
		SceneManager.goto_flagged()
