"""
	Scene Manager:
		Changes Main Scene to a Specfied or Flagged File Path(s)
		Loads Scenes via Background Loading
		
	Dependencies - ActorManager (To move party after scene change)
"""

extends Node

# Load Resources
onready var main_scenes = FileTools.json_to_dict("res://Classes/Directories/MainScenes.json")
onready var fade_screen = preload("res://Singletons/SceneManager/FadeScreen.tscn")

#  Current Scene Instance
var current_scene = null
#A previously visited path that has been flagged. May be returned to with goto_flagged()
var flagged_scene_path := ""

#Warp Registry
var id_property_name = "name"
var warp_registry = NodeRegistry.new(id_property_name)

# Globally emitted signals about changes in the scene status
signal goto_called()
signal scene_loaded()
signal scene_fully_loaded()

##############
#	Callbacks
###############

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

# Used only while interactive loading in progress
# Repeated calls loader to poll until entire scene is loaded
func _process(_delta):
	if loader == null:
		set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader
		# this call blocks all threads until a section of the scene is fully pollef
		var err = loader.poll()
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			wait_frames = default_wait_frames
			_start_new_scene(resource)
			break
		elif err == OK:
			_update_progress()
		else: # Error during loading.
			Debugger.dprint("Error Loading Scene")
			loader = null
			break

###############
#	Public
###############

func in_save_enabled_scene():
	return current_scene.filename in main_scenes["game_scenes"].values() 

func register_warp(node):
	warp_registry.register(node)
	# Needs Entrance Point and Exit Direction Properties
	if !("entrance_point" in node && "exit_direction" in node):
		Debugger.dprint("ERROR REGISTERING SAVE NODE - No 'entrance_point' or 'exit_direction' properties in node '%s'" % node.name)
		warp_registry.deregister(node)
		return

# Call this function from anywhere to change scene
# Example: SceneManager.goto_scene(path_string, warp_destination_id) 
func goto_scene(scene_id : String, warp_destination_id := "", flag_path := false):
	emit_signal("goto_called")
	var scene_path := ""
		
	if scene_id.find_last(".") != -1 and scene_id.substr(scene_id.find_last("."), 5) == ".tscn": 
		scene_path = scene_id
	else:
		for category in main_scenes.values():
			if category.has(scene_id):
				scene_path = category[scene_id]

	if scene_id == "":  Debugger.dprint("ERROR: Scene Not Valid")	
	if flag_path: flagged_scene_path = current_scene.filename
		
	call_deferred("_deferred_goto_scene", scene_path, warp_destination_id)
	
# Flags current scene before changing scenes
func goto_scene_flag_current(scene_id : String, warp_destination_id := ""):
	goto_scene(scene_id, warp_destination_id, true)

# Will goto scene at location flagged_scene_path
func goto_flagged(): 
	if flagged_scene_path == "":
		Debugger.dprint("ERROR: No Scene has been flagged")
	emit_signal("goto_called")
	EnemyManager.despawn_on()
	call_deferred("_deferred_goto_scene", flagged_scene_path, "")


##############
#	Private
##############

# Milliseconds since game began, save between each scene change
var ticks := 0
# Max amount of milliseconds to allow multiple polls in a single process call
var time_max = 100 # msec
# id of warp spot to appear at in incoming scene
var warp_dest := ""
#Instance of Fade Scene for fading in and out of scenes
var fade
#Interactive Loader
var loader
# Frames to wait before loading begins
# Gives any load animation time to appear before thread blocking begins 
var default_wait_frames := 1
var wait_frames := default_wait_frames


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


# Initializes new scene once it is fully loaded
func _start_new_scene(s):
	#var s = ResourceLoader.load(path) # Load the new scene.
	current_scene = s.instance() # Instance the new scene.
	get_tree().get_root().add_child(current_scene) # Add as child of root
	emit_signal("scene_loaded")
	
	# Reposition Party to Warp Spot
	var warps : Array = warp_registry.nodes
	var party = ActorManager.get_actor("Party")
	if (warp_dest != "" && party && warps.size() > 0):
		var warp = warp_registry.fetch(warp_dest)
		party.reposition(warp.entrance_point, warp.exit_direction)
	warp_dest == ""
	
	# Unfade Animation
	var fade_animation = fade.get_node("TextureRect/AnimationPlayer")
	fade_animation.play_backwards("Fade")
	yield(fade_animation, "animation_finished")
	fade.queue_free()
	
	emit_signal("scene_fully_loaded")
	
	
# Allows updates to be printed or displayed everytime scene section is polled by the loader
func _update_progress():
	pass
