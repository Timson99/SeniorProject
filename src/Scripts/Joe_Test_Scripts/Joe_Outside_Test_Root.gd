extends Node


export var camera_bounds = {"is_static": false,
							"max_x" : 100000, 
							"min_x" : -100000,
							"max_y" : -100000,
							"min_y" : 100000,
							}

#export var music_track_path = "res://Assets/Music/No_Place_Like_Home (temp).ogg"

export var enemies_spawnable: bool = true
export var max_enemies = 6
export var enemy_variations = ["Bully", "SampleEnemy"]

# Called when the node enters the scene tree for the first time.
func _ready():
	#BgEngine.facilitate_track_changes(music_track_path)
	pass

	


