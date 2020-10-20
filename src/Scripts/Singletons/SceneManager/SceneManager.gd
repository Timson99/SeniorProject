extends Node

onready var MainScenes = preload("res://Scripts/Resource_Scripts/MainScenes.gd").new()
onready var fade_screen = preload("res://Scripts/Singletons/SceneManager/FadeScreen.tscn")
var current_scene = null
var saved_scene_path = null

signal goto_called()
signal scene_loaded()
signal scene_fully_loaded()


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
# Call this function from anywhere to change scene
# Example: SceneManager.goto_scene(path_string, warp_destination_id) 
func goto_scene(scene_id : String, warp_destination_id := "", save_path = false):
	emit_signal("goto_called")
	if save_path:
		saved_scene_path = current_scene.filename
	if scene_id.find_last(".") != -1 and scene_id.substr(scene_id.find_last("."), 5) == ".tscn": 
		pass
	elif scene_id in MainScenes.explore_scenes:
		scene_id = MainScenes.explore_scenes[scene_id]
	elif scene_id in MainScenes.battle_scenes:
		scene_id = MainScenes.battle_scenes[scene_id]
	else:
		Debugger.dprint("ERROR: Scene Not Valid")
	
	call_deferred("_deferred_goto_scene", scene_id, warp_destination_id)
	
func goto_saved(): 
	emit_signal("goto_called")
	call_deferred("_deferred_goto_scene", saved_scene_path, "")

# Switches Scenes only when it is safe to do so
func _deferred_goto_scene(path, warp_destination_id):
	
	var fade = fade_screen.instance()
	get_tree().get_root().add_child(fade)
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	
	fade_animation.play("Fade")
	yield(fade_animation, "animation_finished")
	
	current_scene.free()
	var s = ResourceLoader.load(path) # Load the new scene.
	current_scene = s.instance() # Instance the new scene.
	get_tree().get_root().add_child(current_scene) # Add as child of root
	emit_signal("scene_loaded")
	var warps : Array = get_tree().get_nodes_in_group("Warp")
	var party : Array = get_tree().get_nodes_in_group("Party")
	
	
	if (warp_destination_id != "" && party.size() == 1 && warps.size() >= 1):
		for warp in warps:
			if ("warp_destination_id" in warp && 
			warp.warp_id == warp_destination_id):	
				party[0].reposition(warp.entrance_point, warp.exit_direction)
				break
	
	fade_animation.play_backwards("Fade")
	yield(fade_animation, "animation_finished")
	fade.queue_free()
	emit_signal("scene_fully_loaded")
	
	
	
	

