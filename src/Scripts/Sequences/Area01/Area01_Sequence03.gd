extends Resource

#Beginning of Attempt 2

static func instructions():
  return [
		["Actor-call", "Area01_Outside_Root", "execute_glow"],
		["Signal", "Area01_Outside_Root", "glow_complete"],
		["Actor-call", "Area01_Outside_Root", "increment_attempt"],
		["Scene", "Area01_House_Room", "Reentry"],
		["Actor-call", "C1", "change_skin", "AtHome"],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Fall_Sideways"],
		["Actor-call", "C1", "set_collision", false],
		
		["Actor-call", "Party", "tween_pos", Vector2(-61, -67), 2.0],
		["Signal", "Party", "tween_pos_completed"],
		
		["Actor-set", "C1", "exploring", true],
		["Actor-call", "C1", "set_collision", true],
  ]


"""
["Actor-set", "Party", "C2_in_party", false],
["Actor-set", "Party", "C3_in_party", false],
["Actor-call", "Party", "on_load"],
["Actor-call", "C1", "change_skin", "AtHome"],
["Actor-set", "C1", "exploring", false],
["Actor-call", "C1", "set_anim", "Rest_Closed"],
["Actor-call", "C1", "set_collision", false],
["Actor-set", "Party", "position", Vector2(-61, -67)],
["Actor-call", "C1", "flip_horizontal", true],
["Delay", 2.0],
["Actor-call", "C1", "flip_horizontal", false],
["Actor-set", "C1", "exploring", true],
["Actor-sync", "C1", "move_to_position", Vector2(0, 40)],
["Actor-call", "C1", "set_collision", true],
"""
