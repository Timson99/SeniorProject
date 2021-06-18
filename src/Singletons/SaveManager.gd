"""
	SaveManager
		Saves/Loads data between SaveManager and the World
		Read/Writes data between SaveManager and Filesystem
		Registers and Tracks Save Nodes
			Loads data into GameObjects when a new scene is loaded
			Saves/Collects data from GameObjects when a scene is about to change
			
	Dependencies
		SceneManager (To know when scene transitions occur to save and load scene data)
	
"""

extends Node

### PERSISTENT SAVE DATA ###
var data : Dictionary = {} setget , get_data

### SAVE NODE PROPERTIES ###
# Variable name that nodes store their save id under
var id_property_name = "save_id"
#Registered Save Nodes for the current scene
var registry = NodeRegistry.new(id_property_name)

### SAVE FILE PROPERTIES ###
# Name of the Save Files, Appear in Menu and used when files saved to data folder
const save_files = ["Save01", "Save02", "Save03", "DevSave01", "DevSave02", "DevSave03"]
# Whether or not to encript files 
var encrypt = false
# Read by SaveLoadMenu.gd, updated by SaveFile.gd
var last_used_save_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("scene_loaded", self, "restore_save_data")
	SceneManager.connect("goto_called", self, "collect_save_data")
	_deferred_on_load() # Calls restore data on first physics frame
	
##############
#	Public 
##############

"""
	A SAVE NODE has data that may be saved from and loaded into a scene
	To register as a SAVE NODE, it must:
	1) Call SaveManager.register(self)
	2) A save_id string
	3) A save method that returns a dictionary of data to save
	4) (optional) An on_load method to be called after data is loaded into the node
"""
# Registers a node as a save node
func register(node):
	registry.register(node)
	# Needs a save method
	if !node.has_method("save"):
		Debugger.dprint("ERROR REGISTERING SAVE NODE - No save method FOR NODE '%s'" % node.name)
		registry.deregister(node)
		return


# For external public use - force updates an existing data point 
func update_entry_property(id : String, prop : String, new_value):
	collect_save_data()
	if typeof(new_value) != TYPE_STRING:
		new_value = var2str(new_value)
	if (id in data) and (prop in data[id]):
		data[id][prop] = new_value 


# Saves all registered Save Node's persistent data and Game metadata to a file 
func save_game( file_name = save_files[last_used_save_index] ):
	collect_save_data() 
	data["__metadata__"] = {"current_scene" : SceneManager.flagged_scene_path}
	FileTools.save_game_from_file(file_name, data, encrypt)


# Load's data back into all Save Node's persistent data
# Switches scenes to the destination indicated in save file's metadata
func load_game( file_name = save_files[last_used_save_index] ):
	var load_data_dict = FileTools.load_game_from_file(file_name, encrypt)
	for node_id in load_data_dict.keys():
		_collect_from(load_data_dict[node_id], node_id )
	var metadata = data["__metadata__"]
	var destination = metadata["current_scene"]
	SceneManager.goto_scene(destination)


##############
#	Signal Callbacks 
##############

# Loading SaveManager -> World:  Loads save data back into all save nodes
# Calls on_load function in save data after data is loaded, to allow node to intialize with newly obtained data
func restore_save_data():
	for node in registry.get_nodes():
		_restore_to(node)
	_on_load_callback()

# Saving World -> SaveManager: Collects data from world and saves it in data dictionary
# Save Data is updated whenever there is a change of scene or before the scene is saved
# When updating, keys that do not exist in this scene are not updated and left alone
func collect_save_data():	
	var registered_nodes = registry.get_nodes()
	for node in registered_nodes:
		if !node.has_method("save"):
			print("save node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		if node_data.size() == 0:
			print("save node '%s' save() returns no data, skipped" % node.name)
			continue 
		_collect_from(node_data, node.get(id_property_name))

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

# Takes node_data from Save File or World and stores in persistent save data under id
# Update is done property by property, so existing properties 
# 	not in node_data are neither modifed nor destroyed
func _collect_from(node_data : Dictionary, node_id : String):
	# Creates new node entry if save node not yet logged into data
	if !(node_id in data):
		data[node_id] = {}
	# Stringifies nonstring data for file writing and
	# inserts modified properties in key by key
	for key in node_data.keys():
		if typeof(node_data[key]) != TYPE_STRING:
			node_data[key] = var2str(node_data[key])
		data[node_id][key] = node_data[key] 

# All save data filed under the node id is loaded back into the node
func _restore_to(node : Object): 
	var id = node.get(id_property_name)
	if(data.has(id)):
		for i in data[id].keys():
			node.set(i, str2var(data[id][i]))

# Makes sure on_load callback is called when the game begins
func _deferred_on_load():
	yield(get_tree(), "physics_frame")
	_on_load_callback()
			
# Calls on_load on all save nodes
func _on_load_callback():
	for node in registry.get_nodes():
		if node.has_method("on_load"):
			node.on_load()	

			
