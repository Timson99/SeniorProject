extends Button

#var destination = "res://Scenes/Tim_Test_Scenes/TestTileMap.tscn"

func _on_Load_pressed():
	SaveFileManager.load_game();
	#SceneManager.goto_scene(destination)
