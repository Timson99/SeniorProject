#Makes Bully get Knocked Out


extends Resource

static func instructions():
  return [
		["Actor-set", "Bully", "exploring", false],
		["Actor-call", "Bully", "change_anim", "Sleep_Closed"],
		["Signal", "SceneManager", "scene_fully_loaded"],
		["Dialogue", "Bully_Attempt1_2"],
		["Signal", "DialogueManager", "end"],
		
  ]
