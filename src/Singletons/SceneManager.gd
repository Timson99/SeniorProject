extends Node

onready var MainScenes = preload("res://Classes/Directories/MainScenes.gd").new()
onready var fade_screen = preload("res://Singletons/SceneManager/FadeScreen.tscn")
var current_scene = null
var saved_scene_path = null

signal goto_called()
signal scene_loaded()
signal scene_fully_loaded()

var loader
var wait_frames
var time_max = 100 # msec
var fade
var warp_dest

var ticks = null


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
	EnemyHandler.despawn_on()
	call_deferred("_deferred_goto_scene", saved_scene_path, "")

# Switches Scenes only when it is safe to do so
func _deferred_goto_scene(path, warp_destination_id):
	warp_dest = warp_destination_id
	fade = fade_screen.instance()
	get_tree().get_root().add_child(fade)
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	fade_animation.play("Fade")
	yield(fade_animation, "animation_finished")
	
	
	ticks = OS.get_ticks_msec()
	current_scene.queue_free() # Get rid of the old scene.
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		Debugger.dprint("Error Loading Scene")
		return
	set_process(true)
	wait_frames = 1


	
func start_new_scene(s):
	#var s = ResourceLoader.load(path) # Load the new scene.
	current_scene = s.instance() # Instance the new scene.
	get_tree().get_root().add_child(current_scene) # Add as child of root
	emit_signal("scene_loaded")
	var warps : Array = get_tree().get_nodes_in_group("Warp")
	var party : Array = get_tree().get_nodes_in_group("Party")
	
	if (warp_dest != "" && party.size() == 1 && warps.size() >= 1):
		for warp in warps:		
			if ("warp_destination_id" in warp && 
			warp.warp_id == warp_dest):	
				party[0].reposition(warp.entrance_point, warp.exit_direction)
				break
	
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	fade_animation.play_backwards("Fade")

	ticks = null
	yield(fade_animation, "animation_finished")
	fade.queue_free()
	warp_dest = null
	emit_signal("scene_fully_loaded")
	

func update_progress():
	pass
	

func _process(_delta):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:

		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			start_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			Debugger.dprint("Error Loading Scene")
			loader = null
			break
		
	
	
	
	

