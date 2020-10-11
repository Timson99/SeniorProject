extends Resource


static func instructions():
	return [
		
				# Actor (async or sync), Actor ID, command, time in seconds, optional paramter (either a flag or Vector2 position) 
		
		["Actor-sync", "PChar1", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor-sync", "PChar2", "change_sequenced_follow_formation", 0, "split"],
				
		["Actor-sync", "PChar3", "change_sequenced_follow_formation", 0, "split"],
		
		["Actor-async", "PChar1", "move_to_position", 3, Vector2(-127, -15)],
		
		["Actor-async", "PChar1", "move_to_position", 3, Vector2(0, -15)],
		
		["Actor-async", "PChar2", "move_to_position", 3, Vector2(-127, 5)],
		
		["Actor-async", "PChar2", "move_to_position", 3, Vector2(0, 5)],
		
		["Actor-async", "PChar3", "move_to_position", 3, Vector2(-127, 25)],
		
		["Actor-async", "PChar3", "move_to_position", 3, Vector2(0, 25)],
		
		["Actor-sync", "PChar1", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor-sync", "PChar2", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor-sync", "PChar3", "change_sequenced_follow_formation", 0, "following"],
		
		["Actor-async", "PChar1", "move_to_position", 3, Vector2(-127, 30)],
		
	]
