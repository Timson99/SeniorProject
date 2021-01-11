extends Resource


static func instructions():
	return [
		
		# Actor (async or sync), Actor ID, command, time in seconds or flag, optional paramter (position is Vector2 position) 
		
		["Actor-call", "C1", "change_follow", "split"],
		["Actor-call", "C2", "change_follow", "split"],
		["Actor-call", "C3", "change_follow", "split"],
		["Actor-call", "C1", "restore_speed"],
		["Actor-call", "C1", "restore_anim_speed"],
		["Actor-async", "C1", "move_up", 1], 
		["Actor-async", "C1", "move_right", 1], 
		["Actor-async", "C1", "move_down", 1], 
		["Actor-async", "C1", "move_left", 1], 
		["Actor-call", "C1", "set_speed", 120],
		["Actor-call", "C1", "scale_anim_speed", 2],
		["Actor-async", "C1", "move_up", 1], 
		["Actor-async", "C1", "move_right", 1], 
		["Actor-async", "C1", "move_down", 1], 
		["Actor-async", "C1", "move_left", 1], 
		["Actor-call", "C1", "restore_speed"],
		["Actor-call", "C1", "scale_anim_speed", 2.5],
		["Actor-async", "C1", "move_up", 1], 
		["Actor-async", "C1", "move_right", 1], 
		["Actor-async", "C1", "move_down", 1], 
		["Actor-async", "C1", "move_left", 1], 
		["Actor-call", "C1", "restore_anim_speed"],
		["Actor-call", "C1", "change_follow", "following"],
		["Actor-call", "C2", "change_follow", "following"],
		["Actor-call", "C3", "change_follow", "following"],
	]
