extends Resource


static func instructions():
	return [
		
		#["Actor-async", "PChar1", "move_up", 3],
		#["Actor-async", "Party", "party_follow_formation", false]
		#["Actor-async", "Party", "party_follow_formation", true],
		
		["Actor-async", "PChar1", "move_up", 1, "split"], 
		
		["Actor-async", "PChar1", "move_left", 1, "split"], 
		
		["Actor-async", "PChar1", "move_down", 1, "split"], 
		
		["Actor-async", "PChar3", "move_right", 0.5, "split"], 
		
		["Actor-async", "PChar1", "move_right", 0.8, "following"], 
		
		#["Actor-async", "Party1", "move_down", 3],
		
		#["Actor-async", "Party1", "move_right", 3],
		
		#["Actor", "Party", "move_up", 3], 
		
		#["Actor", "Party", "move_left", 3],
		
		#["Actor", "Party", "move_down", 3], 
		
		#["Actor", "Party", "move_up", 3], 
		
		#["Actor", "Party", "move_left", 2.5], 
		
		#["Actor", "Party", "move_down", 2.5],
		
		#["Actor", "Party", "move_up", 3],
		
		#["Actor", "Party", "move_left", 2.0],
		
		#["Actor", "Party", "move_down", 2.0], 
		
		#["Actor", "Party", "move_right", 5.0],
		
		#["Actor", "Party", "move_left", 5.0],
		
		#["Actor", "Party", "move_up", 3.0],
		

	]
