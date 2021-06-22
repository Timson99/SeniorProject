extends Area2D

signal play_sound_effect()

export(String) var warp_destination_id = ""
export(String) var warp_scene_id = ""
export(Enums.Dir) var exit_direction
export(bool) var one_way

# Vector directions to align center of right, left, up, or 
# down edges of the player collision box with the player's
# register point
var entrance_point := Vector2()
# Size of iternal warp scene collision square being scaled
const square_size = Vector2(16,16)
const player_relative_box = {
	Enums.Dir.Up: Vector2(0, 0),
	Enums.Dir.Down: Vector2(0, 8),
	Enums.Dir.Left: Vector2(-8, 4),
	Enums.Dir.Right: Vector2(8, 4),
}

func _ready():
	entrance_point = calculate_exit()
	SceneManager.register_warp(self)
	self.connect("body_entered", self, "_on_WarpBlock_body_entered")


func calculate_exit(): 
	var box_size = Vector2(square_size.x * scale.x, square_size.y * scale.y)
	var exit = get_global_position()
	match exit_direction:
		Enums.Dir.Up:
			exit = Vector2(exit.x, exit.y - box_size.y/2 - 1) + player_relative_box[exit_direction]
		Enums.Dir.Down:
			exit = Vector2(exit.x, exit.y + box_size.y/2 + 1) + player_relative_box[exit_direction]
		Enums.Dir.Left:
			exit = Vector2(exit.x - box_size.x/2 - 1, exit.y) + player_relative_box[exit_direction]
		Enums.Dir.Right:
			exit = Vector2(exit.x + box_size.x/2 + 1, exit.y) + player_relative_box[exit_direction]
	return exit

func _on_WarpBlock_body_entered(body):
	var party = ActorManager.get_actor("Party")
	if party && body == party.active_player and !one_way:
		SceneManager.goto_scene(warp_scene_id, warp_destination_id)
		emit_signal("play_sound_effect")
		
