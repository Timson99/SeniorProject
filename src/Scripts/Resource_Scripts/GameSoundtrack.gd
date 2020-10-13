extends Resource

const tracks: Dictionary = {
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn": "res://Assets/Music/End_of_Days.ogg",
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn": "res://Assets/Music/The_Void_Beckons.ogg",
	"res://Scenes/Explore_Scenes/Area01/Area01_Outside01.tscn": "res://Assets/Music/No_Place_Like_Home (temp).ogg",
	"res://Scenes/Joe_Test_Scenes/TestTileMap_Joe.tscn": "res://Assets/Music/Cosmic_Explorers.wav"
	}
	
static func get_track_path(scene_path):
	return tracks[scene_path]
