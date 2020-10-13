extends Node


const SOUNDTRACK = preload("res://Scripts/Resource_Scripts/GameSoundtrack.gd")

onready var music_player = AudioStreamPlayer.new()
onready var tween_fade_out = Tween.new()
onready var tween_fade_in = Tween.new()

var transition_duration_in: float = 1.00 # seconds
var transition_duration_out: float = 1.00 # seconds
var transition_type_in: int = 0 # LINEAR
var transition_type_out: int = 1 # SINE

const min_volume_value: float = -20.0 # in dB
const max_volume_value: float = 0.0 # in dB
var current_scene: Node = null
var seek_position: float = 0.0
var reset_seek_position: float = 0.0 # starts track from beginning



func _ready():
	add_child(music_player)
	add_child(tween_fade_in)
	add_child(tween_fade_out)
	music_player.set_volume_db(-40) 
	#SceneManager.connect("scene_fully_loaded", self, "request_playback")
	SceneManager.connect("goto_called", self, "request_playback_paused")
	#yield(SceneManager, "scene_fully_loaded")
	yield(get_tree(), "idle_frame")
	request_playback(SceneManager.current_scene)


# Loads audio file in AudioStreamPlayer and plays it
func request_playback(next_scene: Node) -> void:
	music_player.stream = load(SOUNDTRACK.get_track_path(next_scene.get_filename()))
	print(SOUNDTRACK.get_track_path(next_scene.get_filename()))
	if current_scene && next_scene.get_filename() == current_scene.get_filename():
		fade_in(music_player, seek_position)
	else:
		fade_in(music_player, reset_seek_position)
	print("PLAYING")
	current_scene = next_scene
	
	
# Pauses audio playback 
func request_playback_paused(next_scene) -> void:
	seek_position = music_player.get_playback_position()
	fade_out(music_player)



# Transitions playback from max volume to min volume
func fade_out(audio_player) -> void:
	tween_fade_out.interpolate_property(audio_player, "volume_db", 
			max_volume_value, min_volume_value, transition_duration_out, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	

# Stops audio track completely after fade out
func _on_FadeOut_tween_completed(object, key):
	object.stop()


#Transitions playback from min volume to max volume
func fade_in(audio_player, seek_position: float) -> void:
	audio_player.play(seek_position)
	tween_fade_in.interpolate_property(audio_player, "volume_db", 
			min_volume_value, max_volume_value, transition_duration_in, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()

	
# Switches songs mid-scene after receiving appropriate signal
func swap_songs_midscene(new_song) -> void:
	music_player.stream = load(new_song)
	music_player.play()
	print("Playing new song in same scene")
	
