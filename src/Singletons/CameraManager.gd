extends Node2D

"""
	CameraManager
	
	Dependencies
		ActorManager ( To register self and find the party )
		
"""

# Create the 2D Camera Node
onready var camera : Camera2D = Camera2D.new()
# Create the tween node for interpolation
var tween = Tween.new()

# Returns global viewport object
onready var viewport = get_viewport()
# Vector2 of viewert x and y size in pixels
onready var viewport_size = viewport.size

#Position of Camera when Static (Center of Default Viewport Position)
onready var static_pos = Vector2(viewport_size.x/2,viewport_size.y/2)

#Possible states of camera -> Following Party, Sequenced, Static
enum State {OnParty, Sequenced, Static}
# Current State 
var state = State.Static

# lines cutoff at top and bottom of screen
var y_cutoff : int
# How much the original viewport dimensions are scaled to fit the window
var vp_scale : int

######
# Callbacks
######

func _ready():
	get_tree().connect("screen_resized", self, "resize_screen")
	SceneManager.connect("scene_loaded", self, "release_camera")
	
	#Disable if Fullscreen Stretch is allowed
	resize_screen()
	ActorManager.register_actor(self)
	
	#Initialize Camera2D
	camera.process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
	add_child(camera)
	camera.current = true
	camera.position = static_pos
	
	#Initialize Tween
	tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child(tween)
	
#######
# Signal Callbacks
#######


func resize_screen():
	
	#Code settings required for below to work, may be set in project.godot
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_VIEWPORT,
		SceneTree.STRETCH_ASPECT_IGNORE, 
		Vector2(320,240) 					# Viewport Dimensions
	)
	
	var window_size = OS.get_window_size()
	
	# Calculates Max Possible scale of viewport's x and y sizes inside the window size 
	#Disable x cutoff -> No vertical lines will appear outside window -> Prefer Vertical Letterbox
	var scale_x = floor(window_size.x / viewport.size.x)
	#Minimizes y cutoff -> Horizontal Lines may appear outside window -> Minimizes Horizontal Letterbox
	var scale_y = round(window_size.y / viewport.size.y)
	#Disable Y Cutoff -> No Horizontal lines will appear outside window -> Prefer Horizontal Letterbox
	#var scale_y = floor(window_size.y / viewport.size.y)
	
	# Viewport scale clamps to minimum of x and y scale
	var scale = max(1, min(scale_x, scale_y))
	
	# Caclulate the new viewport size and attach it
	###############################################
	var scaled_screen_size = viewport.size * scale # Calculated Size of Viewport
	# Difference between window and screen ( + is blank space, - is cuttoff
	var diff = window_size - scaled_screen_size
	var diffhalf = (diff * 0.5).floor() # Coordinates of Viewport in the Window
	viewport.set_attach_to_screen_rect(Rect2(diffhalf, scaled_screen_size))
	
	#Prevent Flicker -> Overlays unused space with black letterbox bars
	###################################################################
	var odd_offset = Vector2(int(scaled_screen_size.x) % 2, int(scaled_screen_size.y) % 2)
	VisualServer.black_bars_set_margins(
		max(diffhalf.x, 0), # prevent negative values, they make the black bars go in the wrong direction.
		max(diffhalf.y, 0),
		max(diffhalf.x, 0) + odd_offset.x,
		max(diffhalf.y, 0) + odd_offset.y
	)
	
	# Sets CameraManager members for this new configuration
	y_cutoff = abs(min(0, int(diff.y))) # pixels cutoff at top and bottom of screen
	vp_scale = scale
	
	# Debug Suite
	#print("Window Size: %s" % str(window_size))
	#print("Viewport Scaled To: %s"  % str(viewport.size * scale))
	#print("Scale X: %s , Scale Y: %s" % [  str(scale_x), str(scale_y)]   )
	#print(y_cutoff)
	

# Use signals for state changes rather than process constant checks
func _physics_process(_delta):
	
	var party = ActorManager.get_party()

	#if !party and state == State.OnParty and state != State.Static: 
		#state_to_static()
	#elif party and state == State.Static and state != State.OnParty: 
		#state_to_party()
		
	if party and state == State.Static and state != State.OnParty: 
		state_to_party()
	
	if state == State.Sequenced:
		# Moving camera has discrete integer position
		camera.position = Vector2(round(camera.position.x), round(camera.position.y))
		camera.align()
		
	elif state == State.OnParty && party:
		var party_pos = party.active_player.get_global_position()	
		camera.position = Vector2(round(party_pos.x), round(party_pos.y))
		if "camera_bounds" in SceneManager.current_scene:
			var bounds = SceneManager.current_scene.camera_bounds
			
			if(bounds["is_static"]):
				camera.position = static_pos
				return
			
			var cuttoff_in_viewport = floor((y_cutoff/2) / float(vp_scale))
			var screen_offset_y_min = bounds["min_y"] - (viewport_size.y/2 - cuttoff_in_viewport)
			var screen_offset_y_max = bounds["max_y"] + (viewport_size.y/2 - cuttoff_in_viewport)
			
			if bounds["min_x"] + viewport_size.x/2 <= bounds["max_x"] - viewport_size.x/2:
				camera.position.x = clamp(camera.position.x, bounds["min_x"] + viewport_size.x/2, bounds["max_x"] - viewport_size.x/2)
			if screen_offset_y_max <= screen_offset_y_min:
				camera.position.y = clamp(camera.position.y, screen_offset_y_max, screen_offset_y_min)
		camera.align()
	

####
#	Public
####

# Call from a scene root, sets x and y boundaries of the camera
func set_scene_boundaries(x_max, y_max):
	pass
	
	

func release_camera():
	state = State.Static
	
func grab_camera():
	if state != State.Sequenced:
		state = State.Sequenced
		return true
	else:
		return false
		

func state_to_party():
	state = State.OnParty

func state_to_static():
	state = State.Static
	camera.position = static_pos
	
func state_to_sequenced():
	state = State.Sequenced

# COROUTINE -> Moves camera to position in seconds
func move_to_position(destination : Vector2, seconds := 60.0):
	tween.interpolate_property(self, "position", camera.position, destination, seconds)
	tween.start()
	yield(tween, "tween_completed")
	
# COROUTINE -> Moves camera to Party in seconds
func move_to_actor(actor_id : String, seconds : float):
	var destination = Vector2(0,0)
	var actor = ActorManager.get_actor(actor_id)
	if !actor:
		Debugger.dprint("CAMERA ERROR - Cannot move to actor with id '%s', not found in scene" % actor_id)
	destination = actor.get_global_position()
	yield(move_to_position(destination, seconds), "completed")
	
# COROUTINE -> Moves camera to Party in seconds
func move_to_party(seconds : float):
	var destination = Vector2(0,0)
	var party = ActorManager.get_party()
	if !party:
		Debugger.dprint("CAMERA ERROR - Cannot move to party, party not found")
	destination = party.active_player.get_global_position()
	yield(move_to_position(destination, seconds), "completed")

