extends Button

var destination = "res://Scenes/Tim_Test_Scenes/Opening.tscn"


func _ready():
	pass


func _on_Load_pressed():
	SaveManager.load_game();
	SceneManager.goto_scene(destination, -1)
