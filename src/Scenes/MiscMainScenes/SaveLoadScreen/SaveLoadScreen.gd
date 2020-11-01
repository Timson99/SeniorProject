extends Control

var save_file_scene = preload("res://Scenes/MiscMainScenes/SaveLoadScreen/SaveFile.tscn")
onready var button_container = $Control/VBoxContainer
onready var tween = $Tween

var save_files_num = SaveManager.save_files.size()
var input_id = "Menu"
var default_focused = 1
var focused = default_focused 
var buttons = []

var scroll_time = 0.15
var max_y = 32
var min_y = max_y + ((save_files_num - 3) * (-64))

# Called when the node enters the scene tree for the first time.
func _ready():
	var save_file_names = SaveManager.save_files
	"""
	for file_name in save_file_names:
		var save_file = save_file_scene.instance()
		save_file.save_file_name = file_name
		button_container.add_child(save_file)
	"""
	buttons = button_container.get_children()
	buttons[focused-1].get_node("AnimatedSprite").animation = "on"


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
	buttons[focused-1].accept()
