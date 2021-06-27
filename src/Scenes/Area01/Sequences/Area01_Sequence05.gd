#Resets back to Room

extends Resource

#End  of Attempt 2

static func instructions():
  return [
		["Actor-set", "Bully", "exploring", false],
		["Actor-call", "Bully", "change_anim", "Sleep_Closed"],
		["Signal", "SceneManager", "scene_fully_loaded"],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 234), true],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Up"],
		["Delay", 0.5],
		
		["Actor-call", "Camera", "grab_camera"],
		["Actor-call", "Camera", "move_to_position", Vector2(-24, 170), 1.0],
		["Signal", "CameraManager", "complete"],
		["Delay", 0.5],
		["Actor-call", "Camera", "move_to_party", 1.0],
		["Signal", "CameraManager", "complete"],
		["Actor-call", "Camera", "release_camera"],
		
		
		
		
		["Actor-call", "Area01_Outside_Root", "execute_glow"],
		["BG_Audio", "fade_out", 0.5],
		["Delay", 0.75],
		["Actor-call", "C1", "flip_horizontal", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		#["Signal", "Area01_Outside_Root", "glow_complete"],
		["Actor-set", "C1", "exploring", false],
		["Delay", 0.75],
		["Actor-call", "C1", "play_anim", "Fall_Upright"],
		["BG_Audio", "play_sound", "Falling02"],
				
		["Actor-call", "Camera", "grab_camera"],
		["Actor-call", "Party", "tween_pos_relative", Vector2(0, 320), 0.5],
		["Signal", "Party", "tween_pos_completed"],
		#NEXT SCENE
		["Actor-call", "Area01_Outside_Root", "increment_attempt"],
		["Scene", "Area01_House_Room", "Reentry"],
		["Actor-set", "Camera", "position", Vector2(72,-300)],
		["Actor-call", "C1", "change_skin", "AtHome"],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Fall_Sideways"],
		["Actor-call", "C1", "set_collision", false],
		["Actor-call", "C1", "flip_horizontal", true],
		["Actor-call", "Area01_House_Room", "shade"],
		
		["Actor-call", "Camera", "move_to_position", Vector2(-61 + 128, -67 + 152), 0.75],
		["Actor-call", "Party", "tween_pos", Vector2(-61, -67), 1.0],
		["Signal", "Party", "tween_pos_completed"],
		["BG_Audio", "play_sound", "HitBed02"],
		["Actor-call", "Camera", "release_camera"],
		["Actor-call", "C1", "play_anim", "Rest_Closed"],
		["Delay", 0.5],
		["Actor-call", "Area01_House_Room", "shade_tween", 0.35],
		["Signal", "Area01_House_Room", "shade_tween_complete"],
		["Delay", 0.2],
		["Actor-call", "C1", "play_anim", "Rest_Opened"],
		["Delay", 0.8],
		["Actor-call", "C1", "flip_horizontal", false],
		["Actor-set", "C1", "exploring", true],
		["Actor-sync", "C1", "move_to_position", Vector2(0, 40), false],
		["Actor-call", "C1", "set_collision", true],
		["BG_Audio", "request_playback","No Place Like Home"],
		["Dialogue", "Monologue"],
		["Signal", "DialogueManager", "end"],
  ]

