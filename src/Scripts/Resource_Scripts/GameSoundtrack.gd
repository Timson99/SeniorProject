extends Resource

const tracks: Dictionary = {
	
	# Placeholder songs for scenes
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn": "res://Assets/Music/End_of_Days.ogg",
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn": "res://Assets/Music/The_Void_Beckons.ogg",
	"res://Scenes/Explore_Scenes/Area01/Area01_Outside01.tscn": "res://Assets/Music/No_Place_Like_Home (temp).ogg",
	
	
	# Placeholder songs for midscene song changes
	"Test Scene Switch": "res://Assets/Music/Cosmic_Explorers (temp).ogg"
	}
	
static func get_track(scene_path):
	return tracks[scene_path]
