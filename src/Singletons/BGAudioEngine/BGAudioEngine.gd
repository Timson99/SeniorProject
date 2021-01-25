extends Node

# Sountrack resource file set aside for now; scenes currently will hold their own
# music tracks
#const SOUNDTRACK = preload("res://Scripts/Resource_Scripts/GameSoundtrack.gd")

signal audio_finished()

onready var _music_player: AudioStreamPlayer = get_node("BackgroundMusic")
onready var tween_fade_out: Tween = get_node("FadeOut")
onready var tween_fade_in: Tween = get_node("FadeIn")

var transition_type_in: int = 0 # LINEAR
var transition_type_out: int = 0 # SINE

const min_volume_value: float = -80.0 # in dB
const max_volume_value: float = 0.0 # in dB
var current_song: String


func _ready():
	pass


func facilitate_track_changes(possible_new_song: String):
	yield(get_tree(), "idle_frame")
	if possible_new_song != "" && possible_new_song != current_song:
		if _music_player.is_playing():
			request_playback_paused()
		request_playback(possible_new_song)
	else:
		pass
	
# Asymmetric playback/pausing code currently due to abrupt stopping that occurs
# when a song is called to stop WITHIN the playback paused method
func request_playback(new_song: String, fadein_blocked=false, fadein_duration=1.0) -> void:
	_music_player.stream = load(new_song)
	_music_player.play()
	if not fadein_blocked:
		fade_in(fadein_duration)
	current_song = new_song
	emit_signal("audio_finished")
	
	
func request_playback_paused(fadeout_blocked=false, fadeout_duration=1.0) -> void:
	if not fadeout_blocked:
		fade_out(fadeout_duration)
	#_music_player.stop()


func fade_out(fadeout_time: float) -> void:
	tween_fade_out.interpolate_property(_music_player, "volume_db", 
			max_volume_value, min_volume_value, fadeout_time, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	yield(tween_fade_out, "tween_completed")
	_music_player.stop()
	emit_signal("audio_finished")


func fade_in(fadein_time: float) -> void:
	tween_fade_in.interpolate_property(_music_player, "volume_db", 
			min_volume_value, max_volume_value, fadein_time, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()
	yield(tween_fade_in, "tween_completed")
	
	
func swap_songs_abrupt(new_song: String) -> void:
	_music_player.stop()
	_music_player.stream = load(new_song)
	_music_player.play()
	emit_signal("audio_finished")

