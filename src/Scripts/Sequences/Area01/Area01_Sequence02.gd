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

