#Makes Bully get Knocked Out


extends Resource

static func instructions():
  return [
		["Actor-set", "Bully", "exploring", false],
		["Actor-call", "Bully", "change_anim", "Sleep_Closed"],
		
  ]
