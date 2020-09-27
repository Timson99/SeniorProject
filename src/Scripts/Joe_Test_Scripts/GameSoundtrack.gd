extends Node

const tracks: Dictionary = {
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn": "res://Assets/Music/End_of_Days.ogg",
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn": "res://Assets/Music/The_Void_Beckons.ogg"
	}
	
static func get_track_path(scene_path):
	return tracks[scene_path]
