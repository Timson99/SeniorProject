extends AutoSelection

var save_file_scene = preload("res://Scenes/General/SaveLoadMenu/SaveFile.tscn")
onready var button_container = $Control/VBoxContainer
onready var tween = $Tween


var save_file_ids = ["Save01","Save02","Save03","Save04","Save05","Save06"]
var save_files_num = save_file_ids.size()

var scroll_time = 0.10

var max_y = 32
var min_y : int

enum Mode {Load, Save}
export (Mode) var current_mode

# Called when the node enters the scene tree for the first time.
func _ready():
	min_y = max_y + ((save_files_num - 3) * (-64))
	
	create_and_activate(save_file_ids)
	
	var last_used_save_index = get_index_by_value(SaveManager.last_used_save_file)
	set_selected_by_index(last_used_save_index)


func set_selected_by_index(new_index):
	.set_selected_by_index(new_index)
	if !tween.is_active() and new_index > 2:
		button_container.rect_position.y = max_y + (new_index-2)*-64 


func set_selected_from_input(direction):
	if tween.is_active() or !(direction in ["up", "down"]):
		return
		
		
	# Select default if nothing currently selected
	if no_initial_selection and selected_index == null:
		selected_index = default_selected_index
		select_current()
		return
		
	var next_index = get_index_after_input(selected_index, direction)
	
	var new_pos
	if next_index > 2: new_pos = max_y + (next_index-2)*-64 
	else: new_pos = max_y
		
		
	#var pos_change = (new_pos != button_container.rect_position.y)
	#if(selected_index != null && next_index != selected_index && pos_change):
	tween.interpolate_property(button_container, "rect_position:y", 
		button_container.rect_position.y, new_pos, scroll_time)
	tween.start()
	yield(tween, "tween_completed")
		
	set_selected_by_index(next_index)
	
	
	
func accept():
	if tween.is_active() || selected_index == null:
		return
	.accept()
	var selected_save_file_name = get_current_value()
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
