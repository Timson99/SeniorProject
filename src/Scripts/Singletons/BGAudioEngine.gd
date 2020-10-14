extends Node


const SOUNDTRACK = preload("res://Scripts/Resource_Scripts/GameSoundtrack.gd")

onready var _music_player: AudioStreamPlayer = get_node("BackgroundMusic")
onready var tween_fade_out: Tween = get_node("FadeOut")
onready var tween_fade_in: Tween = get_node("FadeIn")

var transition_duration_in: float = 1.00 # seconds
var transition_duration_out: float = 2.00 # seconds
var transition_type_in: int = 0 # LINEAR
var transition_type_out: int = 1 # SINE

const min_volume_value: float = -80.0 # in dB
const max_volume_value: float = 0.0 # in dB
var current_song_path: String
var seek_position: float = 0.0
var reset_seek_position: float = 0.0 # starts track from beginning


func _ready():
	SceneManager.connect("goto_called", self, "request_playback_paused")
	yield(get_tree(), "idle_frame")
	request_playback(SceneManager.current_scene.get_filename())


# Loads audio file in AudioStreamPlayer and plays it
func request_playback(next_song_path: String) -> void:
	_music_player.stream = load(SOUNDTRACK.get_track(next_song_path))
	print(SOUNDTRACK.get_track(next_song_path))
	if current_song_path && next_song_path == current_song_path:
		fade_in(seek_position)
	else:
		fade_in(reset_seek_position)
	current_song_path = next_song_path
	
	
# Pauses audio playback 
func request_playback_paused() -> void:
	seek_position = _music_player.get_playback_position()
	fade_out()


# Transitions playback from max volume to min volume
func fade_out() -> void:
	tween_fade_out.interpolate_property(_music_player, "volume_db", 
			max_volume_value, min_volume_value, transition_duration_out, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	yield(tween_fade_out, "tween_completed")
	_music_player.stop()


#Transitions playback from min volume to max volume
func fade_in(seek_position: float) -> void:
	_music_player.play(seek_position)
	tween_fade_in.interpolate_property(_music_player, "volume_db", 
			min_volume_value, max_volume_value, transition_duration_in, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()
	yield(tween_fade_in, "tween_completed")
	
func swap_songs_abrupt(new_song) -> void:
	_music_player.stop()
	_music_player.stream = load(SOUNDTRACK.get_track(new_song))
	_music_player.play()

