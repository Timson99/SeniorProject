+++
title = "BGAudioEngine.gd"
description = ""
author = ""
date = "2021-06-14"
+++

<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

**Extends:** [Node](../Node)

## Description

## Property Descriptions

### regular\_battle\_song

```gdscript
var regular_battle_song
```

--------- Common Songs ----------

### regular\_battle\_victory

```gdscript
var regular_battle_victory
```

### game\_over

```gdscript
var game_over
```

### tween\_fade\_out

```gdscript
var tween_fade_out: Tween
```

### tween\_fade\_in

```gdscript
var tween_fade_in: Tween
```

### transition\_type\_in

```gdscript
var transition_type_in: int = 0
```

### transition\_type\_out

```gdscript
var transition_type_out: int = 0
```

### min\_volume\_value

```gdscript
var min_volume_value: float = -63
```

in dB

### max\_volume\_value

```gdscript
var max_volume_value: float = 0
```

in dB

### current\_song

```gdscript
var current_song: String
```

### saved\_song

```gdscript
export var saved_song: String = ""
```

### paused\_position

```gdscript
var paused_position: float
```

### music\_offset

```gdscript
var music_offset: int
```

### se\_offset

```gdscript
var se_offset: int
```

### baseline\_music\_volume

```gdscript
var baseline_music_volume: float
```

### baseline\_se\_volume

```gdscript
var baseline_se_volume: float
```

### new\_music\_volume

```gdscript
var new_music_volume: float
```

### new\_se\_volume

```gdscript
var new_se_volume: float
```

## Method Descriptions

### change\_music\_volume

```gdscript
func change_music_volume(new_db: float)
```

### change\_sfx\_volume

```gdscript
func change_sfx_volume(new_db: float)
```

### facilitate\_track\_changes

```gdscript
func facilitate_track_changes(possible_new_track: String)
```

### request\_playback

```gdscript
func request_playback(new_song: String, fadein_blocked = false, fadein_duration = 1) -> void
```

### request\_playback\_paused

```gdscript
func request_playback_paused(fadeout_blocked = false, fadeout_duration = 1) -> void
```

### fade\_out

```gdscript
func fade_out(fadeout_time = 2) -> var
```

### fade\_in

```gdscript
func fade_in(fadein_time = 2) -> var
```

### swap\_songs\_abrupt

```gdscript
func swap_songs_abrupt(new_song: String) -> void
```

### play\_battle\_music

```gdscript
func play_battle_music()
```

### play\_game\_over

```gdscript
func play_game_over()
```

### play\_battle\_victory

```gdscript
func play_battle_victory()
```

### play\_next

```gdscript
func play_next(song: String)
```

### save\_song

```gdscript
func save_song(song_to_save = "", save_pos = true)
```

### return\_from\_battle

```gdscript
func return_from_battle()
```

### play\_sound

```gdscript
func play_sound(sound_sample: String)
```

### play\_jingle

```gdscript
func play_jingle(jingle: String)
```

## Signals

- signal audio_finished(): 
