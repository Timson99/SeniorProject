extends Button

func _ready():
	pass


func _on_Load_pressed():
	SaveManager.load_game();
	SceneManager.goto_scene("res://Scenes/Test_Scenes/Opening.tscn", -1)
