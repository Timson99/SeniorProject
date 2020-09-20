extends Node

#signal midscene_music_change()

onready var _music_player = $BackgroundMusic
onready var tween_fade_out = get_node("FadeOut")
onready var tween_fade_in = get_node("FadeIn")

export var transition_duration_in: float = 1.00 # seconds
export var transition_duration_out: float = 1.00 # seconds
export var transition_type_in: int = 0 # LINEAR
export var transition_type_out: int = 1 # SINE

const min_volume_value: float = -40.0
const max_volume_value: float = 0.0
var current_scene: String = ""
var seek_position: float = 0.0
var reset_seek_position: float = 0.0


var tracks: Dictionary = {
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene1.tscn": "res://Assets/Music/End_of_Days.ogg",
	"res://Scenes/Joe_Test_Scenes/BGEngineTestScene2.tscn": "res://Assets/Music/The_Void_Beckons.ogg"
	}


func _ready():
	SceneManager.connect("scene_fully_loaded", self, "request_playback")
	SceneManager.connect("goto_called", self, "request_playback_paused")
	# BGEngineTestScene2.connect("midscene_song_change", self, "swap_songs_midscene")



# Loads audio file in AudioStreamPlayer and plays it
func request_playback(next_scene) -> void:
	print("PLAYING MUSIC")
	$BackgroundMusic.stream = load(tracks.get(next_scene))
	#print("Current scene: %s" % current_scene.get_file())
	#print("Next scene: %s" % next_scene.get_file())
	if next_scene == current_scene:
		print(seek_position)
		fade_in($BackgroundMusic, seek_position)
	else:
		print(reset_seek_position)
		fade_in($BackgroundMusic, reset_seek_position)
	#print($BackgroundMusic.is_playing())
	current_scene = next_scene
	
	
# Pauses audio playback 
func request_playback_paused(next_scene) -> void:
	print("STOPPING MUSIC")
	#print("Current scene: %s" % current_scene.get_file())
	#print("Next scene: %s" % next_scene.get_file())
	seek_position = $BackgroundMusic.get_playback_position()
	print(seek_position)
	fade_out($BackgroundMusic)
	#print($BackgroundMusic.is_playing())


#Transitions playback from max volume to min volume
func fade_out(audio_player) -> void:
	#print("Start fade out")
	tween_fade_out.interpolate_property(audio_player, "volume_db", 
			max_volume_value, min_volume_value, transition_duration_out, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	#print("Fade out start")


func _on_FadeOut_tween_completed(object, key):
	object.stop()


#Transitions playback from min volume to max volume
func fade_in(audio_player, seek_position: float) -> void:
	#print("Start fade in...")
	audio_player.play(seek_position)
	tween_fade_in.interpolate_property(audio_player, "volume_db", 
			min_volume_value, max_volume_value, transition_duration_in, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()
	#print("Fade in finished")
	
	
#func swap_songs_midscene(new_song) -> void:
	#fade_out($BackgroundMusic)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
