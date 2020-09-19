extends Node


var test_data = {
	"1" : 1,
	"2" : 2,
	"3" : 3
}

func save_game():
	var save_game = File.new()
	save_game.open_encrypted_with_pass ("user://savegame.save", File.WRITE, "gobblesser123")
	var node_data = test_data
	save_game.store_line(to_json(node_data))
	save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return 
	save_game.open_encrypted_with_pass ("user://savegame.save", File.READ, "gobblesser123")
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		test_data = node_data
	save_game.close()
