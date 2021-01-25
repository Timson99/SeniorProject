extends Node
signal node_data_extracted(node_data)

const save_files = ["Save01", "Save02", "Save03", "DevSave01", "DevSave02", "DevSave03"]
var current_save_index = 0

var encrypt = false

func _ready():
	SceneManager.connect("goto_called", self, "update_persistent_data")

func save_game( file_name = save_files[current_save_index] ):
	update_persistent_data()
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
	var persistent_data = PersistentData.data
	for node_id in persistent_data.keys():
		save_game.store_line(to_json(persistent_data[node_id]))
	save_game.close()
	
	
func update_persistent_data():	
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		if node_data.size() == 0:
			print("persistent node '%s' save() returns no data, skipped" % node.name)
			continue 
		emit_signal("node_data_extracted", node_data)
		#PersistentData.update_entry(node_data)


func load_game( file_name = save_files[current_save_index]  ):
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
		emit_signal("node_data_extracted", node_data)
		#PersistentData.update_entry(node_data) 
	save_game.close()
	SceneManager.goto_scene(destination)
	
func has_save_file(save_name : String):
	save_name = ("unencrypted_" if !encrypt else "") + save_name
	return File.new().file_exists("user://" + save_name + ".save")
