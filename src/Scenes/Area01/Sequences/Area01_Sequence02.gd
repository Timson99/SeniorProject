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
		
		["BG_Audio", "save_song", "No Place Like Home"],
		["BG_Audio", "swap_songs_abrupt", "Bully Encounter"],
		["Dialogue", "Bully_Attempt1_1"],
		["Signal", "DialogueManager", "page_over"],
		["Signal", "DialogueManager", "page_over"],
		
		#Circle Around Player
		["Actor-call", "Bully","set_speed", 30],
		["Actor-async", "Bully", "move_to_position", Vector2(0, -20), false],
		["Actor-async", "Bully", "move_to_position", Vector2(50, 0), false],
		["Actor-async", "Bully", "move_to_position", Vector2(0, 40), false],
		["Actor-async", "Bully", "move_to_position", Vector2(-50, 0), false],
		["Actor-async", "Bully", "move_to_position", Vector2(0, -20), false],
		["Actor-async", "Bully", "move_to_position", Vector2(1, 0), false],
		
		["Signal", "DialogueManager", "page_over"],
		
		["Signal", "DialogueManager", "end"],
		["Actor-call", "Bully","set_speed", 60],
		["Actor-sync", "Bully", "move_to_position", Vector2(8, 0), false],
		["Actor-call", "Bully", "initiate_battle"],
		["BG_Audio", "swap_songs_abrupt", "Smooth Player"],
  ]

