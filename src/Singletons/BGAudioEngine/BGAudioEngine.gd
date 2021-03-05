extends Node

signal audio_finished()

onready var _music_player: AudioStreamPlayer = get_node("BackgroundMusic")
onready var _sound_player: AudioStreamPlayer = get_node("SoundEffects")
onready var tween_fade_out: Tween = get_node("FadeOut")
onready var tween_fade_in: Tween = get_node("FadeIn")

var transition_type_in: int = 0 
var transition_type_out: int = 0 

var min_volume_value: float = -80.0 # in dB
var max_volume_value: float = -15.0 # in dB
var current_song: String
export var saved_song: String
var paused_position: float


func _ready():
	pass


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


func play_with_intro(intro_song: String, looped_song: String):
	facilitate_track_changes(intro_song)
	play_next(looped_song)


func play_battle_music(intro_song: String, battle_song: String):
	save_song()
	paused_position = _music_player.get_playback_position()
	_music_player.stop()
	swap_songs_abrupt(intro_song)
	play_next(battle_song)
	
	
func play_next(song: String):
	yield(_music_player, "finished")
	_music_player.stream = load(MusicTracks.get_track(song))
	current_song = song
	_music_player.play()
	
func save_song(song_to_save=""):
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
	
