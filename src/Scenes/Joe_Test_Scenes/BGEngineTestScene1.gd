extends Control

var next_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("on_Button_pressed", self, "change_to_new_scene")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_to_new_scene():
	SceneManager.goto_scene(next_scene, -1)
