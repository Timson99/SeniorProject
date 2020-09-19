extends Node
signal node_data_extracted(node_data)

func _ready():
	SceneManager.connect("goto_called", self, "update_persistant_data")

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass ("user://savegame.save", File.WRITE, "gobblesser123")
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	
	
func update_persistant_data():	
	var save_nodes = get_tree().get_nodes_in_group("Persistent")
	for node in save_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		emit_signal("node_data_extracted", node_data)
		#PersistantData.update_entry(node_data)


func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	save_game.open_encrypted_with_pass ("user://savegame.save", File.READ, "gobblesser123")
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		emit_signal("node_data_extracted", node_data)
		#PersistantData.update_entry(node_data) 
	save_game.close()
