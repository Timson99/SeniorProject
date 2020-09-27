extends Area2D

export(String) var warp_id = "None"
export(String) var warp_destination_id = "None"
export(String, FILE, "*.tscn") var warp_scene = "res://"
export(Global.Dir) var entrance_direction
export(Vector2) var entrance_point
export(bool) var one_way

func _ready():
	self.connect("body_entered", self, "_on_WarpBlock_body_entered")

func _on_WarpBlock_body_entered(body):
	if body.get_name() == "Player":
		SceneManager.goto_scene(warp_scene, warp_destination_id)
