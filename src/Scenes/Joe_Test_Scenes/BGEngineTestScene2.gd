extends Control

signal midscene_song_change()

var next_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn"
var same_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn"

var song_change = "res://Assets/Music/Smooth_Player.ogg"

# Called when the node enters the scene tree for the first time.
func _ready():
	$SceneChanger.connect("on_SceneChanger_pressed", self, "change_to_new_scene")
	$SameSceneSongChanger.connect("on_SameSceneSongChanger_pressed", self, "change_to_same_scene")
	$MidSceneSongChanger.connect("on_MidSceneSongChanger_pressed", self, "signal_for_song_change")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func change_to_new_scene():
	SceneManager.goto_scene(next_scene, -1)


func change_to_same_scene():
	SceneManager.goto_scene(same_scene, -1)


func signal_for_song_change():
	emit_signal("midscene_song_change", song_change)
