extends ExploreRoot

#export var music_track_path = "res://Assets/Music/No_Place_Like_Home (temp).ogg"


onready var closet = $TileMap/YSort/Closet
onready var main_door_warp = $TileMap/Warp_Outside
onready var main_door_dialogue = $TileMap/Warp_Outside/MainDoorDialogue/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	main_door_warp.monitoring = false
	closet.connect("used", self, "open_main_door")
	
	#BgEngine.facilitate_track_changes(music_track_path)
 

func open_main_door():
	main_door_warp.monitoring = true
	main_door_dialogue.disabled = true
	


