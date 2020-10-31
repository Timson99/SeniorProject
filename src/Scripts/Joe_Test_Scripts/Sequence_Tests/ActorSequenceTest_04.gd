extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds or flag, optional paramter (position is Vector2 position) 
		
		["Actor-async", "C1", "change_follow", "split"],
		
		["Actor-async", "C2", "change_follow", "split"],
				
		["Actor-async", "C3", "change_follow", "split"],
		
		["Actor-async", "C1", "restore_speed"],
		
		["Actor-async", "C1", "restore_anim_speed"],
		
		["Actor-sync", "C1", "move_up", 1], 
		
		["Actor-sync", "C1", "move_right", 1], 
		
		["Actor-sync", "C1", "move_down", 1], 
		
		["Actor-sync", "C1", "move_left", 1], 
		
		["Actor-async", "C1", "set_speed", 120],
		
		["Actor-async", "C1", "scale_anim_speed", 2],
		
		["Actor-sync", "C1", "move_up", 1], 
		
		["Actor-sync", "C1", "move_right", 1], 
		
		["Actor-sync", "C1", "move_down", 1], 
		
		["Actor-sync", "C1", "move_left", 1], 
		
		["Actor-async", "C1", "restore_speed"],
		
		["Actor-async", "C1", "scale_anim_speed", 2.5],
		
		["Actor-sync", "C1", "move_up", 1], 
		
		["Actor-sync", "C1", "move_right", 1], 
		
		["Actor-sync", "C1", "move_down", 1], 
		
		["Actor-sync", "C1", "move_left", 1], 
		
		["Actor-async", "C1", "restore_anim_speed"],
		
		["Actor-async", "C1", "change_follow", "following"],
		
		["Actor-async", "C2", "change_follow", "following"],
		
		["Actor-async", "C3", "change_follow", "following"],
		
	]
