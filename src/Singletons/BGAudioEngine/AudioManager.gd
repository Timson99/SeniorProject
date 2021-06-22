"""
	AudioManager
		Busses adjust SFX and Music relative to each other ( User Configurable )
		StreamPlayer volume adjust volume relative to other tracks ( Developer )

"""
extends Node



#--------- Common Songs ----------
var regular_battle_song = preload("res://Assets/Audio/Music/General/Cosmic Explorers.ogg")
var regular_battle_victory = preload("res://Assets/Audio/Music/General/Battle Victory (Regular).ogg")
var game_over = preload("res://Assets/Audio/Music/General/Game Over.ogg")
#---------------------------------

# Relative Node Resources
#########################
onready var music_player: AudioStreamPlayer = $BackgroundMusic
onready var _sound_player: AudioStreamPlayer = $SoundEffects
onready var tween_fade_out: Tween = $FadeOut
onready var tween_fade_in: Tween = $FadeIn


# BUS PROPERTIES
################
const bus_volume_increments := 6
const bus_audio_levels = 11
var default_music_bus_level := 9 # number of volume increments passed min volume
var default_sfx_bus_level := 8   # number of volume increments passed min volume
var music_bus_level := default_music_bus_level
var sfx_bus_level := default_sfx_bus_level


# Transition types when interpolating fades
var transition_type_in  := Tween.TRANS_LINEAR
var transition_type_out := Tween.TRANS_LINEAR 

# Global max and min volume of busses and tracks
var min_volume_value := -60 # in dB
var max_volume_value := 0 # in dB

# Song Track Properties
var current_song: String
var saved_song: String
var paused_position: float


func _ready():
	set_music_bus_level(music_bus_level)
	set_sfx_bus_level(sfx_bus_level)
	
########################
#	Public: Bus Configuration
########################

# Change the audio level of the music bus ( changes global volume of music ) 
# Used by Config Menu
func set_music_bus_level(level: float):
	music_bus_level = clamp(level, 0, bus_audio_levels) # Level to db
	var new_music_volume = min_volume_value + (music_bus_level * bus_volume_increments)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), 
		clamp(min_volume_value, new_music_volume, max_volume_value)
	)
	
# Change the audio level of the SFX bus ( changes global volume of SFX )
# Used by Config Menu 
func set_sfx_bus_level(level: float):
	sfx_bus_level = clamp(level, 0, bus_audio_levels)
	var new_sfx_volume = min_volume_value + (sfx_bus_level * bus_volume_increments)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), 
		clamp(min_volume_value, new_sfx_volume, max_volume_value)
	)
	

########################
#	Public
########################

# Before process is called, pauses current song and plays this one
func facilitate_track_changes(possible_new_track: String):
	yield(get_tree(), "idle_frame")
	if music_player.is_playing():
		request_playback_paused()
	request_playback(possible_new_track)

# 	
func request_playback(new_song: String, fadein_blocked=false, fadein_duration=1.0) -> void:
	var track = MusicTracks.get_track(new_song)
	music_player.stream = load(track)
	music_player.play(paused_position)
	if paused_position > 0.0:
		paused_position = 0.0
	if not fadein_blocked:
		fade_in(fadein_duration)
	current_song = new_song
	
	
func request_playback_paused(fadeout_blocked=false, fadeout_duration=1.0) -> void:
	if not fadeout_blocked:
		fade_out(fadeout_duration)
	music_player.stop()


func fade_out(fadeout_time=2.0) -> void:
	tween_fade_out.interpolate_property(music_player, "volume_db", 
			max_volume_value, min_volume_value, fadeout_time, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	yield(tween_fade_out, "tween_completed")


func fade_in(fadein_time=2.0) -> void:
	tween_fade_in.interpolate_property(music_player, "volume_db", 
			min_volume_value, max_volume_value, fadein_time, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()
	yield(tween_fade_in, "tween_completed")
	
	
func swap_songs_abrupt(new_song: String) -> void:
	music_player.stop()
	music_player.stream = load(MusicTracks.get_track(new_song))
	music_player.play()


func play_battle_music():
	save_song()
	music_player.stop()
	music_player.stream = regular_battle_song
	music_player.play()
	
	
func play_game_over():
	music_player.stop()
	music_player.stream = game_over
	music_player.play()	
	
	
func play_battle_victory():
	music_player.stop()
	music_player.stream = regular_battle_victory
	music_player.play()	
	
	
func play_next(song: String):
	yield(music_player, "finished")
	music_player.stream = load(MusicTracks.get_track(song))
	current_song = song
	music_player.play()
	
	
func save_song(song_to_save="", save_pos=true):
	if save_pos:
		paused_position = music_player.get_playback_position()
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
	

func play_jingle(jingle: String):
	var temp_min = min_volume_value
	min_volume_value = -30
	fade_out()	
	play_sound(jingle)
	fade_in()
	min_volume_value = temp_min

