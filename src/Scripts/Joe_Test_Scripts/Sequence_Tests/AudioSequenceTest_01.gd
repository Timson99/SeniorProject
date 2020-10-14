extends Resource


static func instructions():
	return [
		
	["BG_Audio", "request_playback_paused"],
	
	["Delay", 2],	
	
	["BG_Audio", "request_playback", "Test Scene Switch"]
	
	#["BG_Audio", "swap_songs_abrupt", "Test Scene Switch"]
		
	]
