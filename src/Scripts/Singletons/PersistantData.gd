extends Node

var data : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	SaveManager.connect("node_data_extracted", self, "update_entry")
	SceneManager.connect("scene_loaded", self, "restore_data")

# Loads persistant data back into all persistant nodes
func restore_data():
	var save_nodes : Array = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if("persistance_id" in node):
			load_pdata(node.persistance_id, node)

# All persistant data under the id is loaded back into the actor
func load_pdata(id : String, actor : Object): 
	if(data.has(id)):
		for i in data[id].keys():
			actor.set(i, str2var(data[id][i]))

# Updates a specific entry in the Persistant Data
func update_entry(node_data : Dictionary): 
		if("id" in node_data):
			PersistantData.data[node_data.id] = node_data; 
			
