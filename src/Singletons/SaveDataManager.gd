"""
	SaveDataManager
		Saves/Loads data between SaveDataManager and the World
		Registers and Tracks Save Nodes
			Loads data into GameObjects when a new scene is loaded
			Saves/Collects data from GameObjects when a scene is about to change
			
		Dependencies
			Scene Manager (To know when scene transitions occur to save and load scene data)
	
"""

extends Node

# Save Data 
var data : Dictionary = {} setget , get_data

#Registered Save Nodes for a given scene
var id_property_name = "save_id"
var registry = NodeRegistry.new(id_property_name)


# Name of the Save Files, Appear in Menu and used when files saved to data folder
const save_files = ["Save01", "Save02", "Save03", "DevSave01", "DevSave02", "DevSave03"]
# Whether or not to encript files 
var encrypt = false
# Read by SaveLoadMenu.gd, updated by SaveFile.gd
# Used in this script as a default save/load index
var last_used_save_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("scene_loaded", self, "restore_data")
	SceneManager.connect("goto_called", self, "update_save_data")
	_deferred_on_load() # Calls restore data on first physics frame
	
##############
#	Public 
##############

"""
	A SAVE NODE has data that may be saved from and loaded into a scene
	To register as a SAVE NODE, is must:
	- Call SaveDataManager.register(self)
	- A save_id string
	- A save method that returns a dictionary of data to save, including the save_id
	-(optional) An on_load method to be called after data is loaded into the node
"""
func register(node):
	if !(id_property_name in node):
		Debugger.dprint("ERROR REGISTERING SAVE NODE - No %s" % id_property_name)
		return
	if node.get(id_property_name) == "":
		Debugger.dprint("ERROR EMPTY STRING ID")
		return
	if !node.has_method("save"):
		Debugger.dprint("ERROR REGISTERING SAVE NODE - No save method")
		return
	registry.register(node)
	

# For external public use - force updates an existing data point 
func update_entry_property(id : String, prop : String, new_value):
	update_save_data()
	if typeof(new_value) != TYPE_STRING:
		new_value = var2str(new_value)
	if (id in data) and (prop in data[id]):
		data[id][prop] = new_value 
		
func save_game( file_name = save_files[last_used_save_index] ):
	update_save_data()
		
	var metadata = {"current_scene" : SceneManager.saved_scene_path}
	FileTools.save_game_from_file(file_name, metadata, encrypt)
	
func load_game( file_name = save_files[last_used_save_index] ):
	var node_data_list = FileTools.load_game_from_file(file_name, encrypt)
	
	var meta_data = node_data_list.pop_front()
	for node_data in node_data_list:
		_update_entry(node_data)
		
	var destination = meta_data["current_scene"]
	SceneManager.goto_scene(destination)

	
##############
#	Signal Callbacks 
##############

# Loading SaveDataManager -> World:  Loads save data back into all save nodes
# Calls on_load function in save data after data is loaded, to allow node to intialize with newly obtain data
func restore_data():
	for node in registry.get_nodes():
		_load_pdata(node)
	_on_load_callback()


# Saving World -> SaveDataManager: Saves data from world and save it in data dictionary
# Save Data is updated whenever there is a change of scene or before the scene is saved
# When updating, keys that do not exist in this scene are not updated and left alone
func update_save_data():	
	var registered_nodes = registry.get_nodes()
	for node in registered_nodes:
		if !node.has_method("save"):
			print("save node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		if node_data.size() == 0:
			print("save node '%s' save() returns no data, skipped" % node.name)
			continue 
		_update_entry(node_data)

##############
#	Debug
##############
		
# Debug data getter for data validation	
func get_data():
	return data
	
# Debug Print Save Data
func print_data():
	for key in data:
		print(key + " -> " + str(data[key]))
		
##############
#	Private
##############

# Updates a specific node entry in the Save Data with World
# Does not remove or modify any data that is not being updated
func _update_entry(node_data : Dictionary):
	if(id_property_name in node_data):
		var node_id = node_data[id_property_name]
		# Stringifies data for file writing
		for prop in node_data.keys():
			if typeof(node_data[prop]) != TYPE_STRING:
				node_data[prop] = var2str(node_data[prop])
		# Creates new node entry if save node not yet logged into data
		# Inserts modified node_data under the proper save id
		for key in node_data.keys():			
			if !(node_id in data):
				data[node_id] = {}
			data[node_id][key] = node_data[key] 
	else: 
		Debugger.dprint("No id in save node")

# All save data file under the node id is loaded back into the node
func _load_pdata(node : Object): 
	var id = node.get(id_property_name)
	if(data.has(id)):
		for i in data[id].keys():
			node.set(i, str2var(data[id][i]))

# Defers Data Restoration to next Physics Frame Call
# Makes sure on_load callback is called when the game begins
func _deferred_on_load():
	yield(get_tree(), "physics_frame")
	_on_load_callback()
			
# Calls on_load on all save nodes
func _on_load_callback():
	for node in registry.get_nodes():
		if node.has_method("on_load"):
			node.on_load()	

			
