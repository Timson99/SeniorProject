extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds, optional paramter (either a flag or Vector2 position) 
		
		["Actor-async", "C1", "change_follow", "split"],
		
		["Actor-async", "C2", "change_follow", "split"],
				
		["Actor-async", "C3", "change_follow", "split"],
		
		["Actor-sync", "C1", "move_up", 1], 
		
		["Actor-sync", "C1", "move_left", 1], 
		
		["Actor-sync", "C1", "move_down", 1], 
		
		["Actor-sync", "C3", "move_right", 0.5], 
		
		["Actor-async", "C1", "move_left", 0.7],
		
		["Actor-async", "C2", "move_up", 1.0],
				
		["Actor-async", "C3", "move_up", 1.0],
		
		["Actor-async", "C1", "move_right", 0.7],
		
		["Actor-async", "C2", "move_down", 1.0],
				
		["Actor-async", "C3", "move_down", 1.0],
		
		["Actor-async", "C1", "change_follow", "following"],
		
		["Actor-async", "C2", "change_follow", "following"],
				
		["Actor-async", "C3", "change_follow", "following"],
		
		["Actor-sync", "C1", "move_up", 1.0], 
		
		["Actor-sync", "C1", "move_left", 0.3], 
		
		["Actor-sync", "C1", "move_down", 0.3], 
		
		["Actor-sync", "C1", "move_left", 0.3], 
		
		["Actor-sync", "C1", "move_down", 0.3], 
		
		["Actor-sync", "C1", "move_left", 0.3], 
		
		["Actor-sync", "C1", "move_down", 0.3], 
		
		["Actor-sync", "C1", "move_left", 0.3], 
		
		["Actor-async", "C1", "change_follow", "split"],
		
		["Actor-async", "C2", "change_follow", "split"],
				
		["Actor-async", "C3", "change_follow", "split"],
		
		["Actor-async", "C1", "change_follow", "following"],
		
		["Actor-async", "C2", "change_follow", "following"],
		
		["Actor-sync", "C1", "move_left", 1.0], 

		["Actor-sync", "C3", "move_left", 1.0], 
		
		["Actor-async", "C3", "change_follow", "following"],
	]
