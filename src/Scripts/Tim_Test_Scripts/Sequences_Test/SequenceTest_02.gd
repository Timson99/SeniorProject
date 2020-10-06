extends Resource


static func instructions():
	return [
		# Component, Method, Vector, Time
		["Camera", "move_to_position", Vector2(0,136), 5],
		#Camera, Method, Optional Time
		["Camera", "move_to_party", 3],
		
		["AI", "PChar1", "move_left", Vector2(123, 123), 4],

	]
