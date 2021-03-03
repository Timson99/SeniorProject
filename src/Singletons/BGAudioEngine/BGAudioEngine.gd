extends Node

signal audio_finished()

onready var _music_player: AudioStreamPlayer = get_node("BackgroundMusic")
onready var _sound_player: AudioStreamPlayer = get_node("SoundEffects")
onready var tween_fade_out: Tween = get_node("FadeOut")
onready var tween_fade_in: Tween = get_node("FadeIn")

var transition_type_in: int = 1 # LINEAR
var transition_type_out: int = 1 # SINE

const min_volume_value: float = -80.0 # in dB
const max_volume_value: float = -10.0 # in dB
var current_song: String
export var saved_song: String
var paused_position: float

func _ready():
	pass


func facilitate_track_changes(possible_new_song: String):
	yield(get_tree(), "idle_frame")
	if _music_player.is_playing():
		request_playback_paused()
	request_playback(possible_new_song)

	
# Asymmetric playback/pausing code currently due to abrupt stopping that occurs
# when a song is called to stop WITHIN the playback paused method
func request_playback(new_song: String, fadein_blocked=false, fadein_duration=2.0) -> void:
	_music_player.stream = load(new_song)
	if paused_position > 0.0:
		_music_player.seek(paused_position)
	else:
		_music_player.play()
	if not fadein_blocked:
		fade_in(fadein_duration)
	current_song = new_song
	emit_signal("audio_finished")
	
	
func request_playback_paused(fadeout_blocked=false, fadeout_duration=2.0) -> void:
	if not fadeout_blocked:
		fade_out(fadeout_duration)


func fade_out(fadeout_time=2.0) -> void:
	tween_fade_out.interpolate_property(_music_player, "volume_db", 
			max_volume_value, min_volume_value, fadeout_time, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	yield(tween_fade_out, "tween_completed")
	emit_signal("audio_finished")


func fade_in(fadein_time=2.0) -> void:
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


func play_with_intro(intro_song: String, looped_song: String):
	facilitate_track_changes(intro_song)
	play_next(looped_song)


func play_battle_music(intro_song: String, battle_song: String):
	saved_song = current_song
	paused_position = _music_player.get_playback_position()
	print(paused_position)
	_music_player.stop()
	swap_songs_abrupt(intro_song)
	play_next(battle_song)
	
	
func play_next(song: String):
	yield(_music_player, "finished")
	_music_player.stream = load(song)
	_music_player.play()
	
	
func return_from_battle():
	print(saved_song)
	facilitate_track_changes(saved_song)
	print(_music_player.is_playing())
		
	
func play_sound(sound_sample: String):
	_sound_player.stream = load(sound_sample)
	_sound_player.play()
	
