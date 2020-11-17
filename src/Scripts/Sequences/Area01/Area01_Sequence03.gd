extends Resource

#Beginning of Attempt 2

static func instructions():
  return [
		["Actor-call", "Area01_Outside_Root", "execute_glow"],
		#["Scene", "Area01_House_Room", "Room_To_House"],
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
