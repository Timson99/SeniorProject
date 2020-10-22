extends Node

var data : Dictionary = {} setget , get_data

signal all_pdata_loaded()

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveManager.connect("node_data_extracted", self, "update_entry")
	SceneManager.connect("scene_loaded", self, "restore_data")
	deferred_restore()
	
func deferred_restore():
	yield(get_tree(), "physics_frame")
	restore_data()

# Loads persistent data back into all persistent nodes
func restore_data():
	var save_nodes : Array = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if("persistence_id" in node):
			_load_pdata(node.persistence_id, node)
	for node in save_nodes:
		if node.has_method("on_load"):
			node.on_load()
	emit_signal("all_pdata_loaded")

# All persistent data under the id is loaded back into the actor
func _load_pdata(id : String, actor : Object): 
	if(data.has(id)):
		for i in data[id].keys():
			actor.set(i, str2var(data[id][i]))

# Updates a specific entry in the Persistent Data
func update_entry(node_data : Dictionary): 
		if("persistence_id" in node_data):
			for prop in node_data.keys():
				if typeof(node_data[prop]) != TYPE_STRING:
					node_data[prop] = var2str(node_data[prop])
			data[node_data.persistence_id] = node_data; 
		else: 
			Debugger.dprint("No id in persistent node")
		
func get_data():
	return data
	
func print_data():
	for key in data:
		print(key + " -> " + str(data[key]))
			
