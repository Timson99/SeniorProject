extends Resource

#Bully Encounter, Attempt 1

static func instructions():
  return [
		["Actor-sync", "Bully", "move_to_position", Vector2(-120, 190)],
		["Actor-call", "Camera", "grab_camera"],
		["Actor-call", "Camera", "move_to_position", Vector2(-120, 190), 1.0],
		["Signal", "CameraManager", "complete"],
		["Delay", 1.0],
		["Actor-call", "Camera", "move_to_party", 1.0],
		["Signal", "CameraManager", "complete"],
		["Actor-call", "Camera", "release_camera"],
		["Dialogue", "Darren"],
		["Signal", "DialogueEngine", "end"],
		["Actor-call", "Bully", "initiate_battle"]
		
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
