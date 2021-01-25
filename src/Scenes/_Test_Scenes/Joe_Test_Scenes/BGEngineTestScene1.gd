extends Control

var next_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn"


func _ready():
	$Button.connect("on_Button_pressed", self, "change_to_new_scene")


func change_to_new_scene():
	SceneManager.goto_scene(next_scene, -1)
