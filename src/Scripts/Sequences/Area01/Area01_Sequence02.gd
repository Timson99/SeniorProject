extends Resource

#Bully Encounter, Attempt 1

static func instructions():
  return [
		["Actor-sync", "C1", "move_to_position", Vector2(-65, 234), true],
		["Actor-sync", "Bully", "move_to_position", Vector2(-95, 234), true],
		["Actor-call", "Camera", "grab_camera"],
		["Actor-call", "Camera", "move_to_position", Vector2(-80, 234), 0.5],
		["Signal", "CameraManager", "complete"],
		["Delay", 0.5],
		["Actor-call", "Camera", "move_to_party", 0.5],
		["Signal", "CameraManager", "complete"],
		["Actor-call", "Camera", "release_camera"],
		
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

