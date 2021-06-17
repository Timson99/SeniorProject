extends Control


export var save_file_name = "Save01"
onready var name_label = $SaveName
onready var availability_label = $DataAvailable


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = save_file_name
	availability_label.text = "Has Data" if SaveFileManager.has_save_file(save_file_name) else "No Data"
	
func accept_load():
	update_current_save()
	if !SaveFileManager.has_save_file(save_file_name):
		SceneManager.goto_scene("Area01_Opening")
	else:
		SaveFileManager.load_game(save_file_name)
		
func accept_save():
	update_current_save()
	SaveFileManager.save_game(save_file_name)
	SceneManager.goto_saved()
	
func update_current_save():
	SaveFileManager.last_used_save_index = SaveFileManager.save_files.find(save_file_name)

