extends Node

var current_scene = null
var fade_screen
signal goto_called()
signal scene_loaded()


func _ready():
	fade_screen = preload("res://Scenes/Test_Scenes/FadeScreen.tscn")
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
# Call this function from anywhere to change scene
# Example: SceneManager.goto_scene(path_string) 
func goto_scene(path, warp_destination_id): 
	#############
	emit_signal("goto_called")
	#GameManager.input_paused = true
	#SaveManager.update_persistant_data() #Call Update Data
	#############
	call_deferred("_deferred_goto_scene", path, warp_destination_id)

# Switches Scenes only when it is safe to do so
func _deferred_goto_scene(path, warp_destination_id): 
	var fade = fade_screen.instance()
	get_tree().get_root().add_child(fade)
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	
	fade_animation.play("Fade")
	yield(fade_animation, "animation_finished")
	
	current_scene.free() #Remove current scene when safe
	var s = ResourceLoader.load(path) # Load the new scene.
	print(path)
	print(s)
	current_scene = s.instance() # Instance the new scene.
	get_tree().get_root().add_child(current_scene) # Add as child of root
	##########
	emit_signal("scene_loaded")
	#PersistantData.restore_data() #Call Restore Data to Nodes
	##########
	if warp_destination_id < 0 && current_scene.get_node("Map/%s" % warp_destination_id) && current_scene.get_node("Map/Player"):
		print("Id Exists")
		var warp_node = current_scene.get_node("Map/%s" % warp_destination_id)
		current_scene.get_node("Map/Player").reposition(warp_node.entrance_point, warp_node.entrance_direction)
	
	fade_animation.play_backwards("Fade")
	yield(fade_animation, "animation_finished")
	
	get_tree().get_root().remove_child(fade)
	
	


