extends Resource


static func instructions():
	return [
		
	["BG_Audio", "request_playback_paused"],
	
	["Delay", 2.0],
	
	["BG_Audio", "request_playback", "res://Assets/Music/Cosmic_Explorers (temp).ogg"],
	
	#["BG_Audio", "swap_songs_abrupt", "res://Assets/Music/Cosmic_Explorers (temp).ogg"]
		
	]
