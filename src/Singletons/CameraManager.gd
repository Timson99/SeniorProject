extends Node2D

"""
	CameraManager
	
	Dependencies
		SceneManager ( To know when to reset boundary and camera position info  )
		ActorManager ( To register self and find the actors to follow and track )
		
		
"""

# Create the 2D Camera Node
onready var camera : Camera2D = Camera2D.new()
# Create the Tween Node for interpolation
var tween = Tween.new()

# Returns global viewport object
onready var viewport = get_viewport()
# Vector2 of viewert x and y size in pixels
onready var viewport_size = viewport.size
# Total y viewport lines cutoff by window
var y_cutoff : int
# How much the original viewport dimensions are scaled to fit the window
var vp_scale : int

#Position of Camera when Static (Center of Default Viewport Position)
onready var default_pos = Vector2(viewport_size.x/2,viewport_size.y/2)
# Whether or not actor is being followed
var following := false
# Actor being followed
var tracked_actor = null

# Scene Specific Boundaries
const default_boundaries := {
	"x_min" : -INF,
	"x_max" : INF,
	"y_min" : -INF,
	"y_max" : INF
}
var boundaries = default_boundaries


######
# Callbacks
######

func _ready():
	get_tree().connect("screen_resized", self, "resize_screen")
	SceneManager.connect("scene_loaded", self, "reset_camera")
	SceneManager.connect("goto_called", self, "reset_boundaries")
	
	resize_screen()
	ActorManager.register(self)
	
	#Initialize Camera2D
	camera.process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
	add_child(camera)
	camera.current = true
	camera.position = default_pos
	
	#Initialize Tween
	tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child(tween)


func _physics_process(_delta):
	# Stop following if tracked actor is no longer trackable	
	var trackable = ( tracked_actor && is_instance_valid(tracked_actor) )
	if	following && !trackable:
		tracked_actor = null
		following = false

	# Track a actor within the specified boundaries
	if following:
		var party_pos = tracked_actor.get_global_position()
		camera.position = Vector2(party_pos.x, party_pos.y)
		_clamp_camera_to_boundaries()

	camera.position = Vector2(round(camera.position.x), round(camera.position.y))
	camera.align()


########
#	Public
########
	
# Track actor node with camera
func track(node):
	tracked_actor = node
	following = true

# Track a actor by an actor_id
func track_id(actor_id : String):
	var actor = ActorManager.get_actor(actor_id)
	if !actor:
		Debugger.dprint("CAMERA ERROR: CANNOT TRACK ACTOR ID '%s', ACTOR NOT FOUND IN SCENE" % actor_id)
	else:
		tracked_actor = actor
		following = true

# Camera will not follow tracked_actor
func camera_free():
	following = false

# Camera follows tracked_actor
func camera_follow():
	following = true

# Call from a scene root, sets x and y boundaries of the camera
func set_scene_boundaries(x_min = -INF, x_max = INF, y_min = -INF, y_max = INF):
	boundaries["x_min"] = x_min
	boundaries["x_max"] = x_max
	boundaries["y_min"] = y_min
	boundaries["y_max"] = y_max

# COROUTINE -> Moves camera to position in seconds
func move_to_position(destination : Vector2, seconds := 60.0):
	tween.interpolate_property(self, "position", camera.position, destination, seconds)
	tween.start()
	yield(tween, "tween_completed")

# COROUTINE -> Moves camera to actor in seconds
func move_to_actor(actor_id : String, seconds : float):
	var destination = Vector2(0,0)
	var actor = ActorManager.get_actor(actor_id)
	if !actor:
		Debugger.dprint("CAMERA ERROR - Cannot move to actor with id '%s', not found in scene" % actor_id)
	destination = actor.get_global_position()
	yield(move_to_position(destination, seconds), "completed")

#######
# Signal Callbacks
#######

# Reset camera to default position when new scene is loaded
func reset_camera():
	camera.position = default_pos

# Clears scene boundaries when goto_called
func reset_boundaries():
	boundaries = default_boundaries

func resize_screen():
	#Code settings required for below to work, may be set in project.godot
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_VIEWPORT,
		SceneTree.STRETCH_ASPECT_IGNORE, 
		Vector2(320,240) 					# Viewport Dimensions
	)
	var window_size = OS.get_window_size()
	
	# Caclulate max possible scale of viewport in x and y directions within window
	###############################################
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
	y_cutoff = abs(min(0, int(diff.y))) # Total y viewport lines cutoff by window
	vp_scale = scale
	
	# Debug Suite
	#print("Window Size: %s" % str(window_size))
	#print("Viewport Scaled To: %s"  % str(viewport.size * scale))
	#print("Scale X: %s , Scale Y: %s" % [  str(scale_x), str(scale_y)]   )
	#print(y_cutoff)
	
######
#	Private
######

func _clamp_camera_to_boundaries():
	# Distance from center of viewport to x viewport border at 1x scale 
	var center_to_x_border = viewport_size.x/2
	var camera_x_min = boundaries["x_min"] + center_to_x_border
	var camera_x_max = boundaries["x_max"] - center_to_x_border
	if camera_x_min <= camera_x_max:
		camera.position.x = clamp(camera.position.x, camera_x_min, camera_x_max)
		
	# Pixels cutoff at both top and bottom of screen in unscaled viewport
	var y_half_cutoff_in_viewport = floor((y_cutoff/2) / float(vp_scale))
	# Distance from center of viewport to y viewport border at 1x scale 
	var center_to_y_border = viewport_size.y/2 - y_half_cutoff_in_viewport
	var camera_y_min = boundaries["y_min"] + center_to_y_border
	var camera_y_max = boundaries["y_max"] - center_to_y_border
	if camera_y_min <= camera_y_max:
		camera.position.y = clamp(camera.position.y, camera_y_min, camera_y_max)
	


