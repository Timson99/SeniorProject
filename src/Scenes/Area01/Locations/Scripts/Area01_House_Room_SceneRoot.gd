 extends ExploreRoot


var persistence_id = "Area01_Data"
var actor_id = "Area01_House_Room"
export var current_attempt = 1

export var track_1 = "No Place Like Home"

var shaded_blue := Color("0500a0") 
var normal_color := Color("ffffff")

onready var map = $TileMap
onready var bed = $YSort/Bed
onready var tween = $Tween


func _ready():
	add_to_group("Persistent")
	ActorEngine.register_actor(self)
	unshade()
	if current_attempt == 1 && !BgEngine._music_player.is_playing():
		BgEngine.facilitate_track_changes(track_1)
	
	
func shade():
	map.modulate = shaded_blue
	bed.modulate = shaded_blue

signal shade_tween_complete
func shade_tween(duration):
	tween.interpolate_property(map, "modulate", null, normal_color, duration)
	tween.interpolate_property(bed, "modulate", null, normal_color, duration)
	tween.start()
	yield(tween, "tween_all_completed")
	emit_signal("shade_tween_complete")
	

func unshade():
	map.modulate = normal_color
	bed.modulate = normal_color
	
func save():
	return {}


