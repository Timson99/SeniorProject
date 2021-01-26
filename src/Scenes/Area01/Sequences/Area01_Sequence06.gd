#Resets back to Room

extends Resource

#Beginning of Attempt 3

static func instructions():
  return [
		["Actor-call", "Bully", "move_to_position", Vector2(-58, 234), true],
		["Actor-call-sync", "C1", "move_to_position_routine", Vector2(-24, 234), true],
	

		#["Delay", 0.5],
		###["Dialogue", "Darren"],
		["Delay", 1.0],
		["Actor-call", "C1", "set_speed", 120],
		["Actor-call", "Bully","set_speed", 120],
		
		["Actor-call", "Bully", "move_to_position", Vector2(-24, 222), true],
		["Actor-call", "C1", "move_to_position", Vector2(-24, 192), true],
		["Delay", 1.0],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 1.0],
		["Actor-set", "C1", "exploring", true],
		["Actor-call-sync", "C1", "move_to_position", Vector2(-24, 176), true],
		["Delay", 0.25],
		["Actor-call", "exit_door", "open"],
		["Delay", 0.25],
		["Actor-call", "Area01_Outside_Root", "fade_world"],
		["Delay", 1.0],
		["Actor-call", "C1", "set_speed", 30],
		["Actor-call-sync", "C1", "move_to_position", Vector2(-24, 80), true],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Idle_Down"],
		["Delay", 0.25],
		["Actor-call", "exit_door", "close"],
		["Delay", 0.25],
  ]
