extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds or flag, optional paramter (position is Vector2 position) 
		
		["Actor-async", "PChar1", "change_follow", "split"],
		
		["Actor-async", "PChar2", "change_follow", "split"],
				
		["Actor-async", "PChar3", "change_follow", "split"],
		
		["Actor-async", "PChar1", "restore_speed"],
		
		["Actor-async", "PChar1", "restore_anim_speed"],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "set_speed", 120],
		
		["Actor-async", "PChar1", "scale_anim_speed", 2],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "restore_speed"],
		
		["Actor-async", "PChar1", "scale_anim_speed", 2.5],
		
		["Actor-sync", "PChar1", "move_up", 1], 
		
		["Actor-sync", "PChar1", "move_right", 1], 
		
		["Actor-sync", "PChar1", "move_down", 1], 
		
		["Actor-sync", "PChar1", "move_left", 1], 
		
		["Actor-async", "PChar1", "restore_anim_speed"],
		
		["Actor-async", "PChar1", "change_follow", "following"],
		
		["Actor-async", "PChar2", "change_follow", "following"],
		
		["Actor-async", "PChar3", "change_follow", "following"],
		
	]
