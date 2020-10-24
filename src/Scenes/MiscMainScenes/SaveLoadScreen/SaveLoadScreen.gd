extends Control

var save_file_scene = preload("res://Scenes/MiscMainScenes/SaveLoadScreen/SaveFile.tscn")
onready var button_container = $Control/VBoxContainer
var save_files_num = 1
var input_id = "Menu"
var default_focused = 1
var focused = default_focused 
var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready():
	"""
	var save_file_names = SaveManager.save_files
	save_files_num = save_file_names.size()
	for file_name in save_file_names:
		var save_file = save_file_scene.instance()
		save_file.save_file_name = file_name
		button_container.add_child(save_file)
	"""
	buttons = button_container.get_children()
	save_files_num = buttons.size()
	buttons[focused-1].get_node("AnimatedSprite").animation = "on"


func up():
	buttons[focused-1].get_node("AnimatedSprite").animation = "off" 
	focused -= 1
	focused = max(1, focused)
	buttons[focused-1].get_node("AnimatedSprite").animation = "on" 
	button_container.rect_position.y = min(button_container.rect_position.y+64,32)

func down():
	buttons[focused-1].get_node("AnimatedSprite").animation = "off" 
	focused += 1
	focused = min(save_files_num, focused)
	buttons[focused-1].get_node("AnimatedSprite").animation = "on" 
	print("Save Files Num %s:" % save_files_num)
	print("Focused %s:" % focused)
	if(focused > 3):
		var min_y = 32 + ((save_files_num - 3) * (-64))
		button_container.rect_position.y = max(button_container.rect_position.y-64,min_y)
	
func accept():
	buttons[focused-1].accept()
