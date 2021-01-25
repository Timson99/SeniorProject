extends Resource


static func instructions():
	return [
		#Actor-type Actor_ID Command, time in seconds or flag, optional param (Vector2 for position)
		["Actor-async", "C1", "move_up", 5],
		["Actor-sync", "C2", "change_follow", "split"],
		#Dialogue, D_ID
		["Dialogue", "d_id"],
		#BG_Audio, command, optional audio_id
		["BG_Audio", "command", "audio_id"],
		#Battle, scene_id
		["Battle", "scnen_id"],
		#Scene, scene_id, optional warp_id
		["Scene", "scene_id", "warp_id"],
		#Camera, command, time in seconds
		["Camera", "move_up", 3],
		#Delay, time in seconds,
		["Delay", 2],
		#Signal, Observed From, Signal Name
		["Signal", "SceneManager", "goto_called"],
		
	]
