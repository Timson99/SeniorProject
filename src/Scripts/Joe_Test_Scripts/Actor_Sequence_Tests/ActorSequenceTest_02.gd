extends Resource


static func instructions():
	return [
		
		#["Actor-async", "PChar1", "move_up", 3],
		#["Actor-async", "Party", "party_follow_formation", false]
		#["Actor-async", "Party", "party_follow_formation", true],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "split"],
				
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor-async", "PChar1", "move_to_position", 3, Vector2(-127, -15)],
		
		["Actor-async", "PChar1", "move_to_position", 3, Vector2(0, -15)],
		
		["Actor-async", "PChar2", "move_to_position", 3, Vector2(-127, 5)],
		
		["Actor-async", "PChar2", "move_to_position", 3, Vector2(0, 5)],
		
		["Actor-async", "PChar3", "move_to_position", 3, Vector2(-127, 25)],
		
		["Actor-async", "PChar3", "move_to_position", 3, Vector2(0, 25)],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar1", "move_to_position", 3, Vector2(-127, 30)],
		
	]
