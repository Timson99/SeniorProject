extends Node

signal audio_finished()

#--------- Common Songs ----------
var regular_battle_song = preload("res://Assets/Audio/Music/General/Cosmic Explorers.ogg")
var regular_battle_victory = preload("res://Assets/Audio/Music/General/Battle Victory (Regular).ogg")
var game_over = preload("res://Assets/Audio/Music/General/Game Over.ogg")
#---------------------------------

onready var _music_player: AudioStreamPlayer = get_node("BackgroundMusic")
onready var _sound_player: AudioStreamPlayer = get_node("SoundEffects")
onready var tween_fade_out: Tween = get_node("FadeOut")
onready var tween_fade_in: Tween = get_node("FadeIn")

var transition_type_in: int = 0 
var transition_type_out: int = 0 

var min_volume_value: float = -63.0 # in dB
var max_volume_value: float = 0.0 # in dB
var current_song: String
export var saved_song: String
var paused_position: float

var music_offset := 6
var se_offset := 12
var baseline_music_volume := max_volume_value - music_offset
var baseline_se_volume := max_volume_value - se_offset
var new_music_volume: float
var new_se_volume: float


func _ready():
	change_music_volume(baseline_music_volume)
	change_sfx_volume(baseline_se_volume)


func change_music_volume(new_db: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		clamp(min_volume_value, new_db, max_volume_value)
	)
	

func change_sfx_volume(new_db: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), 
		clamp(min_volume_value, new_db, max_volume_value)
	)


func facilitate_track_changes(possible_new_track: String):
	yield(get_tree(), "idle_frame")
	if _music_player.is_playing():
		request_playback_paused()
	request_playback(possible_new_track)

	
func request_playback(new_song: String, fadein_blocked=false, fadein_duration=1.0) -> void:
	var track = MusicTracks.get_track(new_song)
	_music_player.stream = load(track)
	_music_player.play(paused_position)
	if paused_position > 0.0:
		paused_position = 0.0
	if not fadein_blocked:
		fade_in(fadein_duration)
	current_song = new_song
	emit_signal("audio_finished")
	
	
func request_playback_paused(fadeout_blocked=false, fadeout_duration=1.0) -> void:
	if not fadeout_blocked:
		fade_out(fadeout_duration)
	_music_player.stop()


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
	_music_player.stream = load(MusicTracks.get_track(new_song))
	_music_player.play()
	emit_signal("audio_finished")


func play_battle_music():
	save_song()
	_music_player.stop()
	_music_player.stream = regular_battle_song
	_music_player.play()
	
	
func play_game_over():
	_music_player.stop()
	_music_player.stream = game_over
	_music_player.play()	
	
	
func play_battle_victory():
	_music_player.stop()
	_music_player.stream = regular_battle_victory
	_music_player.play()	
	
	
func play_next(song: String):
	yield(_music_player, "finished")
	_music_player.stream = load(MusicTracks.get_track(song))
	current_song = song
	_music_player.play()
	
	
func save_song(song_to_save="", save_pos=true):
	if save_pos:
		paused_position = _music_player.get_playback_position()
	if song_to_save:
		saved_song = song_to_save
	else:
		saved_song = current_song	
	
	
func return_from_battle():
	facilitate_track_changes(saved_song)
		
	
func play_sound(sound_sample: String):
	var sound = SoundEffects.get_sound(sound_sample)
	_sound_player.stream = load(sound)
	_sound_player.play()
	

func play_item_jingle():
	var temp_min = min_volume_value
	min_volume_value = -30
	fade_out()	
	play_sound("ItemJingle")
	fade_in()
	min_volume_value = temp_min
	
