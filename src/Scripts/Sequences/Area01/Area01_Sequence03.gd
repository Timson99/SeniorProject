extends Resource

#Beginning of Attempt 2

static func instructions():
  return [
		["Actor-call", "Area01_Outside_Root", "execute_glow"],
		["Signal", "Area01_Outside_Root", "glow_complete"],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "flip_horizontal", true],
		["Delay", 0.5],
		["Actor-call", "C1", "flip_horizontal", false],
		["Delay", 1.0],
		["Actor-call", "C1", "play_anim", "Fall_Upright"],
		
		["Actor-call", "Camera", "grab_camera"],
		["Actor-call", "Party", "tween_pos_relative", Vector2(0, 90), 1.0],
		["Signal", "Party", "tween_pos_completed"],
		
		["Actor-call", "Area01_Outside_Root", "increment_attempt"],
		["Scene", "Area01_House_Room", "Reentry"],
		
		
		["Actor-call", "Camera", "release_camera"],
		["Actor-call", "C1", "change_skin", "AtHome"],
		["Actor-set", "C1", "exploring", false],
		["Actor-call", "C1", "play_anim", "Fall_Sideways"],
		["Actor-call", "C1", "set_collision", false],
		
		["Actor-call", "C1", "flip_horizontal", true],
		["Actor-call", "Party", "tween_pos", Vector2(-61, -67), 2.0],
		["Signal", "Party", "tween_pos_completed"],
		["Actor-call", "C1", "play_anim", "Rest_Closed"],
		["Delay", 2.0],
		["Actor-call", "C1", "flip_horizontal", false],
		["Actor-set", "C1", "exploring", true],
		["Actor-sync", "C1", "move_to_position", Vector2(0, 40)],
		["Actor-call", "C1", "set_collision", true],
  ]

