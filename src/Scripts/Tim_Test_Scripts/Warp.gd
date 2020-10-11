extends Area2D

export(String) var warp_id = "None"
export(String) var warp_destination_id = "None"
export(String) var warp_scene_id = ""
export(Enums.Dir) var entrance_direction
export(bool) var one_way

# Vector directions to align center of right, left, up, or 
# down edges of the player collision box with the player's
# register point
var entrance_point := Vector2()
const square_size = Vector2(16,16)
const player_relative_box = {
	Enums.Dir.Up: Vector2(0, 0),
	Enums.Dir.Down: Vector2(0, 8),
	Enums.Dir.Left: Vector2(-12, 4),
	Enums.Dir.Right: Vector2(12, 4),
}

func _ready():
	entrance_point = calculate_exit()
	self.connect("body_entered", self, "_on_WarpBlock_body_entered")


func calculate_exit(): 
	var box_size = Vector2(square_size.x * scale.x, square_size.y * scale.y)
	var exit = position
	if entrance_direction == Enums.Dir.Up:
		exit = Vector2(exit.x, exit.y - box_size.y/2 - 1) + player_relative_box[entrance_direction]
	elif entrance_direction == Enums.Dir.Down:
		exit = Vector2(exit.x, exit.y + box_size.y/2 + 1) + player_relative_box[entrance_direction]
	elif entrance_direction == Enums.Dir.Left:
		exit = Vector2(exit.x - box_size.y/2 - 1, exit.y) + player_relative_box[entrance_direction]
	elif entrance_direction == Enums.Dir.Right:
		exit = Vector2(exit.x + box_size.y/2 + 1, exit.y) + player_relative_box[entrance_direction]
	return exit

func _on_WarpBlock_body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		SceneManager.goto_scene(warp_scene_id, warp_destination_id)
		
