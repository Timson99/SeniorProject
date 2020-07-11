extends Node

var current_scene = null
var fade_screen

func _ready():
	fade_screen = preload("res://Scenes/FadeScreen.tscn")
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

""" Call this function from anywhere to change scene
	Example: SceneManager.goto_scene(path_string) """
func goto_scene(path, warp_destination_id): 
	call_deferred("_deferred_goto_scene", path, warp_destination_id)

func _deferred_goto_scene(path, warp_destination_id): 

	GameManager.input_paused = true
	
	var fade = fade_screen.instance()
	get_tree().get_root().add_child(fade)
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	fade_animation.connect("animation_finished", self, "fade_out_complete", [path, fade, fade_animation, warp_destination_id])
	fade_animation.play("Fade")

func fade_out_complete(anim_str, path, fade, fade_animation, warp_destination_id):
	
	fade_animation.disconnect("animation_finished", self, "fade_out_complete")
	current_scene.free() #Remove current scene when safe
	var s = ResourceLoader.load(path) # Load the new scene.
	current_scene = s.instance() # Instance the new scene.
	get_tree().get_root().add_child(current_scene) # Add as child of root.
	fade_animation.connect("animation_finished", self, "fade_in_complete", [fade])
	
	print("Map/%s" % warp_destination_id)
	print(current_scene.get_node("Map/%s" % warp_destination_id) )
	print(current_scene.get_node("Map/Player") )
	
	if current_scene.get_node("Map/%s" % warp_destination_id) && current_scene.get_node("Map/Player"):
		print("Id Exists")
		var warp_node = current_scene.get_node("Map/%s" % warp_destination_id)
		current_scene.get_node("Map/Player").reposition(warp_node.entrance_point, warp_node.entrance_direction)
	
	fade_animation.play_backwards("Fade")
	
func fade_in_complete(anim_str, fade):
	GameManager.input_paused = false
	get_tree().get_root().remove_child(fade)
