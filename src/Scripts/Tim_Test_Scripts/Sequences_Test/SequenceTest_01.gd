extends Resource


static func instructions():
	return [
		#AI AI_ID Command, time in seconds
		["AI", "C1", "move_up", 3],
		#Dialogue, D_ID
		["Dialogue", "d_id"],
		#BG_Audio, Audio_id
		["BG_Audio", "audio_id"],
		#Battle, scene_id
		["Battle", "scnen_id"],
		#Scene, scene_id
		["Scene", "scene_id", "warp_id"],
		#Camera, command, time in seconds
		["Camera", "move_up", 3],
		#Delay, time in seconds
		["Delay", 2],
		#Signal
		["Signal", "Scene", "goto_called"],
		
	]
