extends Resource


static func instructions():
	return [
		
		#["Actor-async", "PChar1", "move_up", 3],
		#["Actor-async", "Party", "party_follow_formation", false]
		#["Actor-async", "Party", "party_follow_formation", true],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "split"],
				
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor", "PChar1", "move_to_position", 3, Vector2(110, 0)],
		
		["Actor", "PChar1", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar2", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor", "PChar3", "change_sequenced_follow_formation", 0, "following"],
	]
