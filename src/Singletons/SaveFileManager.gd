"""
	SaveFileManager:
		Saves/Loads data between Files and SaveDataManager
		Used primarily by the SaveLoadMenu and SaveFile Objects
		
		Dependencies:
			SaveDataManager (Gives/Takes data resulting from saves and loads)
"""

extends Node


# Name of the Save Files, Appear in Menu and used when files saved to data folder
const save_files = ["Save01", "Save02", "Save03", "DevSave01", "DevSave02", "DevSave03"]

# Whether or not to encript files 
var encrypt = false

# Read by SaveLoadMenu.gd, updated by SaveFile.gd
# Used in this script as a default save/load index
var last_used_save_index = 0
	
##############
#	Public
##############
	
# Used by SaveFile to determine if a save file exists
func has_save_file(save_name : String):
	save_name = ("unencrypted_" if !encrypt else "") + save_name
	return File.new().file_exists("user://" + save_name + ".save")

# Saves SaveDataManager to specified file name in encrypted or text formats
func save_game( file_name = save_files[last_used_save_index] ):
	SaveDataManager.update_save_data()
	var save_game = File.new()
	var file_path = ""
	##################################
	if encrypt:
		file_path = "user://" + file_name + ".save"
	else:
		file_path = "user://unencrypted_" + file_name + ".save"
	##################################
	##################################
	if encrypt:
		save_game.open_encrypted_with_pass (file_path, File.WRITE, "gobblesser123")
	else:
		save_game.open(file_path, File.WRITE)
	##################################
	save_game.store_line(to_json({"current_scene" : SceneManager.saved_scene_path}))
	var save_data = SaveDataManager.data
	for node_id in save_data.keys():
		save_game.store_line(to_json(save_data[node_id]))
	save_game.close()
	
# Loads encripted or text file formats into SaveDataManager object
func load_game( file_name = save_files[last_used_save_index]  ):
	var save_game = File.new()
	var file_path = ""
	##################################
	if encrypt:
		file_path = "user://" + file_name + ".save"
	else:
		file_path = "user://unencrypted_" + file_name + ".save"
	##################################
	if not save_game.file_exists(file_path):
		Debugger.dprint("ERROR: NO LOAD FILE OF THE GIVEN NAME")
		return # Error! We don't have a save to load
	##################################
	if encrypt:
		save_game.open_encrypted_with_pass(file_path, File.READ, "gobblesser123")
	else:
		save_game.open(file_path, File.READ)
	##################################
	var destination =  parse_json(save_game.get_line())["current_scene"]
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		SaveDataManager._update_entry(node_data) 
	save_game.close()
	SceneManager.goto_scene(destination)
