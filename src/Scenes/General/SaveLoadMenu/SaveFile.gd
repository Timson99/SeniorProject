extends Control


export var save_file_name := "SaveName"
onready var name_label = $SaveName
onready var availability_label = $DataAvailable


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = save_file_name
	availability_label.text = "Has Data" if FileTools.save_file_exists(save_file_name) else "No Data"
	
func accept_load():
	update_current_save()
	if !FileTools.save_file_exists(save_file_name):
		SceneManager.goto_scene("Area01_Opening")
	else:
		SaveManager.load_game(save_file_name)
		
func accept_save():
	update_current_save()
	SaveManager.save_game(save_file_name)
	SceneManager.goto_flagged()
	
func update_current_save():
	SaveManager.last_used_save_file = save_file_name

