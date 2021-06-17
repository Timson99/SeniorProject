extends Area2D

export var scene_id : String
export var save_id = "test_enemy"
export var active = true

func _ready():
	pass
		


func _on_WarpBlock_body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player:
		active = false
		SceneManager.goto_scene(scene_id, "", true)
		
func save():
	var save_dict = {
		"save_id" : save_id,
		"active" : active
	}
	return save_dict
	
func on_load():
	if active:
		self.connect("body_entered", self, "_on_WarpBlock_body_entered")
	else: 
		hide()
		queue_free()
