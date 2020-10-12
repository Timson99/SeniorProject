extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds, optional paramter (either a flag or Vector2 position) 
		
		["Actor-async", "PChar1", "change_follow", "split"],
		
		["Actor-async", "PChar2", "change_follow", "split"],
				
		["Actor-async", "PChar3", "change_follow", "split"],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar3", "move_right", 0.5], 
		
		["Actor-async", "PChar1", "move_left", 0.7],
		
		["Actor-async", "PChar2", "move_up", 1.0],
				
		["Actor-async", "PChar3", "move_up", 1.0],
		
		["Actor-async", "PChar1", "move_right", 0.7],
		
		["Actor-async", "PChar2", "move_down", 1.0],
				
		["Actor-async", "PChar3", "move_down", 1.0],
		
		["Actor-async", "PChar1", "change_follow", "following"],
		
		["Actor-async", "PChar2", "change_follow", "following"],
				
		["Actor-async", "PChar3", "change_follow", "following"],
		
		["Actor-sync", "PChar1", "move_up", 1.0], 
		
		["Actor-sync", "PChar1", "move_left", 0.3], 
		
		["Actor-sync", "PChar1", "move_down", 0.3], 
		
		["Actor-sync", "PChar1", "move_left", 0.3], 
		
		["Actor-sync", "PChar1", "move_down", 0.3], 
		
		["Actor-sync", "PChar1", "move_left", 0.3], 
		
		["Actor-sync", "PChar1", "move_down", 0.3], 
		
		["Actor-sync", "PChar1", "move_left", 0.3], 
		
		["Actor-async", "PChar1", "change_follow", "split"],
		
		["Actor-async", "PChar2", "change_follow", "split"],
				
		["Actor-async", "PChar3", "change_follow", "split"],
		
		["Actor-async", "PChar1", "change_follow", "following"],
		
		["Actor-async", "PChar2", "change_follow", "following"],
		
		["Actor-sync", "PChar1", "move_left", 1.0], 

		["Actor-sync", "PChar3", "move_left", 1.0], 
		
		["Actor-async", "PChar3", "change_follow", "following"],
	]
