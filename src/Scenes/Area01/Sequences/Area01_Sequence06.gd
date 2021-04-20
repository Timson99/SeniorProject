#Resets back to Room

extends Resource

#Beginning of Attempt 3

static func instructions():
  return [
	
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 234), true],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Up"],
		["Actor-sync", "Bully", "move_to_position", Vector2(-58, 234), true],
		["Actor-call", "C1", "play_anim", "Idle_Left"],
		["Delay", 0.5],

		["Dialogue", "Bully_Attempt3_1"],
		["Signal", "DialogueEngine", "page_over"],
		["Actor-call", "C1", "play_anim", "Idle_Up"],
		["Signal", "DialogueEngine", "end"],
		["Actor-call", "C1", "set_speed", 120],
		["Actor-call", "Bully","set_speed", 120],
		
		["Actor-set", "C1", "exploring", true],
		["Actor-async", "C1", "move_to_position", Vector2(-24, 192), true],
		["Actor-async", "C1", "move_to_position", Vector2(0, 2), false],
		["Delay", 0.2],
		["Actor-sync", "Bully", "move_to_position", Vector2(-24, 222), true],
		["Actor-sync", "Bully", "move_to_position", Vector2(0, -2), false],
		["Delay", 0.2],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 0.1],
		["Actor-set", "C1", "exploring", true],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 176), true],
		["Delay", 0.05],
		["Actor-call", "exit_door", "open"],
		["Delay", 0.05],
		["Actor-call", "Area01_Outside_Root", "fade_world"],
		["Delay", 0.05],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 150), true],
		["Actor-call", "C1", "set_speed", 30],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 110), true],
		["Actor-set", "C1", "exploring", false],
		["Delay", 0.5],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 0.5],
		["Actor-call", "exit_door", "close"],
		["BG_Audio", "play_sound", "MetalDoorSlam01"],
		["BG_Audio", "request_playback_paused"],
		["Delay", 0.5],
		["Actor-call", "Area01_Outside_Root", "hide"],
		
		
		["Delay", 3.0],
		["Actor-set", "Party", "C2_in_party", true],
		["Actor-set", "Party", "C3_in_party", true],
		["Scene", "Demo_Transition", ""]
  ]
