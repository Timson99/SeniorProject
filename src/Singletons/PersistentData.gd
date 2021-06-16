"""
	PersistentData
		Saves/Loads data between PersistentData and the World
		Registers and Tracks Persistent Nodes
			Loads data into GameObjects when a new scene is loaded
			Saves/Collects data from GameObjects when a scene is about to change
			
		Dependencies
			Scene Manager (To know when scene transitions occur to save and load scene data)
	
"""

extends Node

# Save Data 
var data : Dictionary = {} setget , get_data

#Registered Persistent Nodes for a given scene
#var registered_nodes := [] setget , get_registered_nodes
var id_property_name = "persistence_id"
var registry = NodeRegistry.new(id_property_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("scene_loaded", self, "restore_data")
	SceneManager.connect("goto_called", self, "update_persistent_data")
	_deferred_on_load() # Calls restore data on first physics frame
	
##############
#	Public -  Reigstration
##############

"""
	A PERSISTENT NODE has data that may be saved from and loaded into a scene
	To register as a PERSISTENT NODE, is must:
	- Call PersistentData.register(self)
	- A persistence_id string
	- A save method that returns a dictionary of data to save, including the persistent_id
	-(optional) An on_load method to be called after data is loaded into the node
"""
func register(node):
	if !(id_property_name in node):
		Debugger.dprint("ERROR REGISTERING PERSISTENT NODE - No persistent_id")
		return
	if !node.has_method("save"):
		Debugger.dprint("ERROR REGISTERING PERSISTENT NODE - No save method")
		return
	registry.register(node)

	
##############
#	Public 
##############

# For external public use - force updates an existing data point 
func update_entry_property(id : String, prop : String, new_value):
	if typeof(new_value) != TYPE_STRING:
		new_value = var2str(new_value)
	if (id in data) and (prop in data[id]):
		data[id][prop] = new_value 


# Updates a specific node entry in the Persistent Data with World
# Does not remove or modify any data that is not being updated
func update_entry(node_data : Dictionary):
	if(id_property_name in node_data):
		var node_id = node_data[id_property_name]
		# Stringifies data for file writing
		for prop in node_data.keys():
			if typeof(node_data[prop]) != TYPE_STRING:
				node_data[prop] = var2str(node_data[prop])
		# Creates new node entry if persistent node not yet logged into data
		# Inserts modified node_data under the proper persistence id
		for key in node_data.keys():			
			if !(node_id in data):
				data[node_id] = {}
			data[node_id][key] = node_data[key] 
	else: 
		Debugger.dprint("No id in persistent node")
		

# Loading PersistentData -> World:  Loads persistent data back into all persistent nodes
# Calls on_load function in persistent data after data is loaded, to allow node to intialize with newly obtain data
func restore_data():
	for node in registry.get_nodes():
		_load_pdata(node)
	_on_load_callback()


# Saving World -> PersistentData: Saves data from world and save it in data dictionary
# Persistent Data is updated whenever there is a change of scene or before the scene is saved
# When updating, keys that do not exist in this scene are not updated and left alone
func update_persistent_data():	
	var registered_nodes = registry.get_nodes()
	for node in registered_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		if node_data.size() == 0:
			print("persistent node '%s' save() returns no data, skipped" % node.name)
			continue 
		update_entry(node_data)

##############
#	Debug
##############
		
# Debug data getter for data validation	
func get_data():
	return data
	
# Debug Print Persistent Data
func print_data():
	for key in data:
		print(key + " -> " + str(data[key]))
		
# Gets registered nodes
func get_registered_nodes():
	return registry.get_nodes()
		
# Debug Print Persistent Nodes in the Scene
func print_registered_nodes():
	print(registry.get_nodes())
		
##############
#	Private
##############

# All persistent data file under the node id is loaded back into the node
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
			
# Calls on_load on all persistent nodes
func _on_load_callback():
	for node in registry.get_nodes():
		if node.has_method("on_load"):
			node.on_load()	

			
