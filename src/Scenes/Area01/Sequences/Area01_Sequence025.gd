#Initiate Battle with Bully

extends Resource

#Bully Encounter, Attempt 2 Beginning

static func instructions():
  return [
		["Actor-async", "Bully", "move_to_position", Vector2(-38, 234), true],
		["Actor-sync", "C1", "move_to_position", Vector2(-8, 234), true],
		["Actor-call", "Camera", "grab_camera"],
		["Actor-sync", "Camera", "move_to_position", Vector2(-24, 234), 0.5],
		["Delay", 0.5],
		
		["Dialogue", "Bully_Attempt2_1"],
		["Signal", "DialogueEngine", "end"],
		["Actor-call", "C1","set_speed", 30],
		["Actor-async", "C1", "move_to_position", Vector2(50, 0), false],
		["Delay", 1.0],
		["Dialogue", "Bully_Attempt2_2"],
		["Actor-call", "Bully","set_speed", 120],
		["Actor-async", "Bully", "move_to_position", Vector2(50, 0), false],
		["Signal", "DialogueEngine", "page_over"],
		["Actor-async", "Camera", "move_to_party", 1.0],
		["Actor-async", "C1", "move_to_position", Vector2(-1, 0), false],
		
		["Signal", "DialogueEngine", "end"],
		["Actor-sync", "Bully", "move_to_position", Vector2(8, 0), false],
		["Actor-call", "Bully", "initiate_battle"]
  ]

