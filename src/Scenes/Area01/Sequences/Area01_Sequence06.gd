#Resets back to Room

extends Resource

#Beginning of Attempt 3

static func instructions():
  return [
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 234), true],
		["Delay", 0.5],
		["Actor-sync", "Bully", "move_to_position", Vector2(-58, 234), true],
		###["Dialogue", "Darren"],
		["Delay", 1.0],
		["Actor-call", "C1", "set_speed", 120],
		["Actor-call", "Bully","set_speed", 120],
		
		["Actor-async", "Bully", "move_to_position", Vector2(-24, 222), true],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 192), true],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 1.0],
		["Actor-set", "C1", "exploring", true],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 176), true],
		["Delay", 0.25],
		["Actor-call", "exit_door", "open"],
		["Delay", 0.25],
		["Actor-async", "Area01_Outside_Root", "fade_world"],
		["Delay", 1.0],
		["Actor-call", "C1", "set_speed", 30],
		["Actor-sync", "C1", "move_to_position", Vector2(-24, 80), true],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 0.25],
		["Actor-call", "exit_door", "close"],
		["Delay", 0.25],
		
		###["Dialogue", "Darren"],
		###["Signal", "DialogueEngine", "page_over"],
		###["Actor-async", "Bully", "move_up", 0.5],
		###["Actor-async", "Bully", "move_right", 0.8],
		###["Signal", "DialogueEngine", "page_over"],
		###["Actor-async", "Bully", "move_down", 0.8],
		###["Actor-async", "Bully", "move_left", 0.5],
		###["Signal", "DialogueEngine", "page_over"],
		
		###["Signal", "DialogueEngine", "end"],
		["Actor-call", "Bully", "initiate_battle"]
  ]
