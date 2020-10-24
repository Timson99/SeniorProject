extends Control


export var save_file_name = "Save01"
onready var name_label = $SaveName
onready var availability_label = $DataAvailable


# Called when the node enters the scene tree for the first time.
func _ready():
	name_label.text = save_file_name
	availability_label.text = "Has Data" if SaveManager.has_save_file(save_file_name) else "No Data"
	
func accept():
	if !SaveManager.has_save_file(save_file_name):
		pass
	else:
		SaveManager.load_game(save_file_name)



