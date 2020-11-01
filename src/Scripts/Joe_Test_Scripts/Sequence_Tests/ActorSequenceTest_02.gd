extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds, optional paramter (either a flag or Vector2 position) 
		
		["Actor-async", "C1", "change_follow", "split"],
		
		["Actor-async", "C2", "change_follow", "split"],
				
		["Actor-async", "C3", "change_follow", "split"],
		
		["Actor-sync", "C1", "move_to_position", 3, Vector2(-127, -15)],
		
		["Actor-sync", "C1", "move_to_position", 3, Vector2(0, -15)],
		
		["Actor-sync", "C2", "move_to_position", 3, Vector2(-127, 5)],
		
		["Actor-sync", "C2", "move_to_position", 3, Vector2(0, 5)],
		
		["Actor-sync", "C3", "move_to_position", 3, Vector2(-127, 25)],
		
		["Actor-sync", "C3", "move_to_position", 3, Vector2(0, 25)],
		
		["Actor-async", "C1", "change_follow", "following"],
		
		["Actor-async", "C2", "change_follow", "following"],
		
		["Actor-async", "C3", "change_follow", "following"],
		
		["Actor-sync", "C1", "move_to_position", 3, Vector2(-127, 30)],
		
	]
