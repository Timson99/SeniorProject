extends "res://Scenes/General/ExploreEnvironment/Scripts/Warp.gd"

onready var transition_sound = SoundEffects.get_sound("EnterDoor01")

func _ready():
	pass 
	
func _on_WarpBlock_body_entered(body):
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1 && body == party[0].active_player and !one_way:
		SceneManager.goto_scene(warp_scene_id, warp_destination_id)
		BgEngine.play_sound(transition_sound)
