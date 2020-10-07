extends Resource


static func instructions():
	return [
		
		["AI", "PChar1", "move_up", 3, AiEngine.PartyState.Following],
		
		["AI", "PChar1", "move_left", 3, AiEngine.PartyState.Following],
		
		["AI", "PChar1", "move_down", 3, AiEngine.PartyState.Following],
		
		["AI", "PChar1", "move_right", 3, AiEngine.PartyState.Following],
		
		["AI", "PChar1", "move_up", 3, AiEngine.PartyState.Split],
		
		["AI", "PChar1", "move_left", 3, AiEngine.PartyState.Split],
		
		["AI", "PChar1", "move_down", 3, AiEngine.PartyState.Split],
		
		["AI", "PChar2", "move_up", 3, AiEngine.PartyState.Split],
		
		["AI", "PChar2", "move_left", 2.5, AiEngine.PartyState.Split],
		
		["AI", "PChar2", "move_down", 2.5, AiEngine.PartyState.Split],
		
		["AI", "PChar3", "move_up", 3, AiEngine.PartyState.Split],
		
		["AI", "PChar3", "move_left", 2.0, AiEngine.PartyState.Split],
		
		["AI", "PChar3", "move_down", 2.0, AiEngine.PartyState.Split],
		
		["AI", "PChar1", "move_right", 5.0, AiEngine.PartyState.Following],
		
		["AI", "PChar3", "move_left", 5.0, AiEngine.PartyState.Split],
		
		["AI", "PChar2", "move_up", 3.0, AiEngine.PartyState.Split],
		
		
		#["AI", "PChar1", "move_right", 2.1, AiEngine.PartyState.Split],
		
		#["AI", "PChar3", "move_left", 3, AiEngine.PartyState.Split],
		
		#["AI", "PChar2", "move_right", 3, AiEngine.PartyState.Split],

	]
