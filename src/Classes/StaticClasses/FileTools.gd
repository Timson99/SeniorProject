"""
DATA LOADER
	Contains Functions for Loading Text Data
	Used for Scene Id's, Enemy Data,  
"""

extends Object

class_name FileTools

#########
# Data File Functions
#########

static func json_to_dict( path : String, int_cast_numerics := false) -> Dictionary:
	var file = File.new()
	if !file.file_exists(path):
		Debugger.dprint("!!! Error - JSON path does not exist : %s" % path)
	file.open(path, file.READ)
	var text = file.get_as_text()
	var dict = parse_json(text) 
	file.close()
	if !dict:
		Debugger.dprint("!!! Error - JSON at path has invalid formatting : %s" % path)
	return dict
	
#########
# Save File Functions
#########

static func save_file_exists(file_name : String) -> bool:
	return ( File.new().file_exists("user://" + file_name + ".save") || 
			 File.new().file_exists("user://" + "unencrypted_" + file_name + ".save") )

# Saves SaveManager to specified file name in encrypted or text formats
static func save_game_from_file( file_name : String, metadata := {}, save_data := {}, encrypt := true) -> void:
	var save_game = File.new()
	var file_path = (( "user://" if encrypt else "user://unencrypted_") + file_name + ".save")
	##################################
	if encrypt:
		save_game.open_encrypted_with_pass (file_path, File.WRITE, "gobblesser123")
	else:
		save_game.open(file_path, File.WRITE)
	##################################
	save_game.store_line(to_json(metadata))
	for node_id in save_data.keys():
		save_game.store_line(to_json(save_data[node_id]))
	save_game.close()
	
# Loads encripted or text file formats into SaveManager object
static func load_game_from_file( file_name : String, encrypt := true) -> Array:
	var save_game = File.new()
	var file_path = (( "user://" if encrypt else "user://unencrypted_") + file_name + ".save")
	##################################
	if not save_game.file_exists(file_path):
		Debugger.dprint("ERROR: NO LOAD FILE OF THE GIVEN NAME '%s'" % file_path)
		return [] # Error! We don't have a save to load
	##################################
	if encrypt:
		save_game.open_encrypted_with_pass(file_path, File.READ, "gobblesser123")
	else:
		save_game.open(file_path, File.READ)
	##################################
	var metadata =  parse_json(save_game.get_line())
	var load_data = [ metadata ]
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		load_data.push_back(node_data) 
	save_game.close()
	return load_data
	
