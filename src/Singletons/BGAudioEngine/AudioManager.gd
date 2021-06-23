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
onready var sound_player: AudioStreamPlayer = $SoundEffects
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
var default_player_volume := max_volume_value # Player's default to max db


var current_song_id := ""

# Properties of a cached song
var cached_song_id := ""
var cached_playback_position := 0.0


func _ready():
	sound_player.volume_db = default_player_volume
	music_player.volume_db = default_player_volume
	music_player.bus = "Music"
	sound_player.bus = "SFX"
	set_music_bus_level(music_bus_level)
	set_sfx_bus_level(sfx_bus_level)
	ActorManager.register(self)
	
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

# Saves the name and playback position of the currently playing song 
func cache_current_music():
	cached_song_id = current_song_id
	cached_playback_position = music_player.get_playback_position()

# Plays music cached from from cached position
func play_cached_music(fade_in_secs := 0.0):
	play_music(cached_song_id, fade_in_secs, cached_playback_position)
	
# COROUTINE -> Plays a music track
#	-Music player can only play one song at a time, (current will be overriden)
#	-If song of the same name is already playing, song will continue playing (no reset)
#	-Plays song, saves id, and optionally fades into the song over time
func play_music(song_id : String, fade_in_secs := 0.0, playback_pos := 0.0 ):
	yield(get_tree(), "idle_frame")
	if music_player.is_playing() && song_id == current_song_id:
		return
	var track = MusicTracks.get_track(song_id)
	music_player.stream = load(track)
	music_player.play(playback_pos)
	current_song_id = song_id
	if ( fade_in_secs > 0.0 ): 
		yield(_fade_in(fade_in_secs), "completed")
	
# COROUTINE -> Stops a music track, clears current id
func stop_music(fade_out_secs := 0.0):
	yield(get_tree(), "idle_frame")
	if music_player.is_playing():
		current_song_id = ""
		if ( fade_out_secs > 0.0 ): 
			yield(_fade_out(fade_out_secs), "completed")
		current_song_id = ""
		music_player.stop()

# COROUTINE -> Plays a sound effect to complete 
#	-Sound player can only play one sound effect at a time, (current will be overriden)
#	-For SFX layering, delegate sound effects duties to individual nodes
func play_sound(sound_sample: String):
	var sound = SoundEffects.get_sound(sound_sample)
	sound_player.stream = load(sound)
	sound_player.play()
	yield(sound_player, "finished")
	
########################
#	Private
########################

# Tweens music player from max_volume to min_volume
func _fade_out(fadeout_time):
	tween_fade_out.interpolate_property(music_player, "volume_db", 
			max_volume_value, min_volume_value, fadeout_time, 
			transition_type_out, Tween.EASE_IN_OUT, 0)
	tween_fade_out.start()
	yield(tween_fade_out, "tween_completed")

# Tweens music player from min_volume to max_volume
func _fade_in(fadein_time):
	tween_fade_in.interpolate_property(music_player, "volume_db", 
			min_volume_value, max_volume_value, fadein_time, 
			transition_type_in, Tween.EASE_IN_OUT, 0)
	tween_fade_in.start()
	yield(tween_fade_in, "tween_completed")
	
