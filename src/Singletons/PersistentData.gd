"""
	PersistentData
		Saves/Loads data between PersistentData and the World
		Registers and Tracks Persistent Nodes
			Loads data into GameObjects when a new scene is loaded
			Saves/Collects data from GameObjects when a scene is about to change
"""

extends Node

# Save Data 
var data : Dictionary = {} setget , get_data

#Registered Persistent Nodes for a given scene
var registered_nodes := [] setget , get_registered_nodes

# Notifies world that save data has been fully loaded into the scene
signal all_pdata_loaded()

# Called when the node enters the scene tree for the first time.
func _ready():
	SceneManager.connect("scene_loaded", self, "restore_data")
	SceneManager.connect("goto_called", self, "update_persistent_data")
	_deferred_restore() # Restore preloaded savefile
	
##############
#	Public - Persitistent Reigstration
##############

"""
	A PERSISTENT NODE has data that may be saved from and loaded into a scene
	To register as a PERSISTENT NODE, is must:
	- Call PersistentData.register(self)
	- A string PersistentData.register(self)
	- A save method that returns a dictionary of data to save, including the persistent_id
	-(optional) An on_load method to be called after data is loaded into the node
"""
func register(node):
	if !("persistence_id" in node):
		Debugger.dprint("ERROR REGISTERING PERSISTENT NODE - No persistent_id")
		return
	if !node.has_method("save"):
		Debugger.dprint("ERROR REGISTERING PERSISTENT NODE - No save method")
		return
	registered_nodes.append(node)
	
# Iterates through node backward to clear out delete objects
func update_registered_nodes():
	for i in range(registered_nodes.size() - 1, -1, -1):
		if !is_instance_valid(registered_nodes[i]):
			registered_nodes.remove(i)

	
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
		if("persistence_id" in node_data):
			var node_id = node_data["persistence_id"]
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
	update_registered_nodes()
	for node in registered_nodes:
		if("persistence_id" in node):
			_load_pdata(node.persistence_id, node)
	for node in registered_nodes:
		if node.has_method("on_load"):
			node.on_load()
	emit_signal("all_pdata_loaded")


# Saving World -> PersistentData: Saves data from world and save it in data dictionary
# Persistent Data is updated whenever there is a change of scene or before the scene is saved
# When updating, keys that do not exist in this scene are not updated and left alone
func update_persistent_data():	
	update_registered_nodes()
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
		
		
func get_registered_nodes():
	update_registered_nodes()
	return registered_nodes
		
# Debug Print Persistent Nodes in the Scene
func print_registered_nodes():
	update_registered_nodes()
	print(registered_nodes)
		
##############
#	Private
##############

# All persistent data file under the actor id is loaded back into the actor
func _load_pdata(id : String, actor : Object): 
	if(data.has(id)):
		for i in data[id].keys():
			actor.set(i, str2var(data[id][i]))

# Defers Data Restoration to nnext Physics Frame Call
# Used to restore preloaded game data on game start (for testing only)
func _deferred_restore():
	yield(get_tree(), "physics_frame")
	restore_data()

			
