extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds or flag, optional paramter (position is Vector2 position) 
		
		["Actor-async", "PChar1", "change_follow", "split"],
		
		["Actor-async", "PChar2", "change_follow", "split"],
				
		["Actor-async", "PChar3", "change_follow", "split"],
		
		["Actor-async", "PChar1", "change_speed", "60"],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "change_speed", "120"],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "restore_default_speed"],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "change_follow", "following"],
		
		["Actor-async", "PChar2", "change_follow", "following"],
		
		["Actor-async", "PChar3", "change_follow", "following"],
		
	]
