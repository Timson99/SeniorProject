extends Control


var next_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn"
var same_scene = "res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn"

var song_change = "res://Assets/Music/Cosmic_Explorers.ogg"


func _ready():
	$SceneChanger.connect("on_SceneChanger_pressed", self, "change_to_new_scene")
	$SameSceneSongChanger.connect("on_SameSceneSongChanger_pressed", self, "change_to_same_scene")
	$MidSceneSongChanger.connect("on_MidSceneSongChanger_pressed", self, "change_song_midscene")



func change_to_new_scene():
	SceneManager.goto_scene(next_scene, -1)


func change_to_same_scene():
	SceneManager.goto_scene(same_scene, -1)


func change_song_midscene():
	BgEngine.swap_songs_midscene(song_change)
