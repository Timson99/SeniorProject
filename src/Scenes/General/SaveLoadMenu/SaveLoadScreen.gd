extends AutoSelection

var save_file_scene = preload("res://Scenes/General/SaveLoadMenu/SaveFile.tscn")
onready var button_container = $Control/VBoxContainer
onready var tween = $Tween


var save_file_ids = ["Save01","Save02","Save03","Save04","Save05","Save06"]
var save_files_num = save_file_ids.size()

var scroll_time = 0.15
var max_y = 32
var min_y : int

enum Mode {Load, Save}
export (Mode) var current_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	
	min_y = max_y + ((save_files_num - 3) * (-64))
	
	activate(save_file_ids)
	
	var last_used_save_index = index_with_value(SaveManager.last_used_save_file)
	set_selected_index(last_used_save_index)


func set_selected_index(new_index):
	.set_selected_index(new_index)
	if tween.is_active():
		return
	if new_index > 2:
		button_container.rect_position.y = max_y + (new_index-2)*-64 


func _change_selected(direction):
	if tween.is_active() or !(direction in ["up", "down"]):
		return
		
	var next_index = _get_next_index(direction, selected_index)
	
	var change
	var condition
	if direction == "up": 
		change =  min(button_container.rect_position.y+64,max_y)
		condition = next_index > 1
	elif direction == "down":
		change = max(button_container.rect_position.y-64,min_y)
		condition = next_index > 2
		
	if(selected_index && condition && next_index != selected_index):
		tween.interpolate_property(button_container, "rect_position:y", 
			button_container.rect_position.y, change, scroll_time)
		tween.start()
		
	._change_selected(direction)
	
	
func accept():
	if tween.is_active() || selected_index == null:
		return
	.accept()
	
	var selected_save_file_name = _get_current_value()
	
	if current_mode == Mode.Load:
		accept_load(selected_save_file_name)
	elif current_mode == Mode.Save:
		accept_save(selected_save_file_name)
		
func cancel():
	if tween.is_active():
		return
	.cancel()
	if current_mode == Mode.Save:
		SceneManager.goto_flagged()
		
		
		
func accept_load(save_file_name):
	SaveManager.last_used_save_file = save_file_name
	if !FileTools.save_file_exists(save_file_name):
		SceneManager.goto_scene("Area01_Opening")
	else:
		SaveManager.load_game(save_file_name)
		
func accept_save(save_file_name):
	SaveManager.last_used_save_file = save_file_name
	SaveManager.save_game(save_file_name)
	SceneManager.goto_flagged()
