extends Resource

class_name MainScenes

var explore_scenes := {
		
	
	#Tim Test Articles
	"TileMapTest" : {
		"scene_path": "res://Scenes/Tim_Test_Scenes/TestTileMap.tscn",
		"spawnable_enemies": false,
		"max_num_of_enemies": 0
					},
	
	#Area 1
	"Area01_House_Room" : {
		"scene_path": "res://Scenes/Explore_Scenes/Area01/Area01_House_Room.tscn",
		"spawnable_enemies": false,
		"max_num_of_enemies": 0
						   },
	"Area01_House01" : {
		"scene_path": "res://Scenes/Explore_Scenes/Area01/Area01_House01.tscn",
		"spawnable_enemies": false,
		"max_num_of_enemies": 0
						},
	"Area01_Outside01" : {
		"scene_path": "res://Scenes/Explore_Scenes/Area01/Area01_Outside01.tscn",
		"spawnable_enemies": false,
		"max_num_of_enemies": 0
						  },
	"Area01_Outside02" : {
		"scene_path": "res://Scenes/Explore_Scenes/Area01/Area01_Outside02.tscn",
		"spawnable_enemies": false,
		"max_num_of_enemies": 0
						 },
	
	# Joe Overworld Test Scenes
	"Joe_Outside_Test_Scene": {
		"scene_path": "res://Scenes/Joe_Test_Scenes/Joe_Outside_Test_Scene.tscn",
		"spawnable_enemies": true,
		"max_num_of_enemies": 5
								}

}

var battle_scenes := {
	
	#Tim Test Articles
	"TestBattle1" : "res://Scenes/Tim_Test_Scenes/WinButton.tscn",
	"DemoBattle" : "res://Scenes/Battle_Scenes/General/Demo_Battle_Scene.tscn",
	"JoeDemoBattle": "res://Scenes/Joe_Test_Scenes/Joe_Demo_Battle.tscn"
	
}
