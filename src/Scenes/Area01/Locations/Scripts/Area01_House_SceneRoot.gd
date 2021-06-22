extends ExploreRoot


export var current_attempt = 1


onready var closet = $TileMap/YSort/Closet
onready var main_door_warp = $TileMap/Warp_Outside
onready var main_door_dialogue = $TileMap/Warp_Outside/MainDoorDialogue/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SaveManager.register(self)
	ActorManager.register_actor(self)
	
	main_door_warp.monitoring = false
	closet.connect("used", self, "open_main_door")
	
func on_load():
	pass
 

func open_main_door():
	main_door_warp.monitoring = true
	main_door_dialogue.disabled = true
	
func save():
	return {}
	


