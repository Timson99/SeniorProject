#Initiate Battle with Bully

extends Resource

#Bully Encounter, Attempt 1

static func instructions():
  return [
		["Actor-async", "Bully", "move_to_position", Vector2(-38, 234), true],
		["Actor-sync", "C1", "move_to_position", Vector2(-8, 234), true],
		["Actor-call", "Camera", "grab_camera"],
		["Actor-sync", "Camera", "move_to_position", Vector2(-24, 234), 0.5],
		["Delay", 0.5],
		
		["Dialogue", "Bully"],
		["Signal", "DialogueEngine", "page_over"],
		
		#Circle Around Player
		["Actor-async", "Bully", "move_to_position", Vector2(0, -20), false],
		["Actor-async", "Bully", "move_to_position", Vector2(50, 0), false],
		["Actor-async", "Bully", "move_to_position", Vector2(0, 40), false],
		["Actor-async", "Bully", "move_to_position", Vector2(-50, 0), false],
		["Actor-async", "Bully", "move_to_position", Vector2(0, -20), false],
		["Actor-async", "Bully", "move_to_position", Vector2(1, 0), false],
		
		["Signal", "DialogueEngine", "page_over"],
		
		["Signal", "DialogueEngine", "end"],
		["Actor-sync", "Bully", "move_to_position", Vector2(8, 0), false],
		["Delay", 0.5],
		["Actor-call", "Bully", "initiate_battle"]
  ]

