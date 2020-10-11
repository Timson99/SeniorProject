extends Node2D

onready var camera : Camera2D = Camera2D.new()
var tween = Tween.new()
onready var screen_size = get_viewport_rect().size
onready var static_pos = Vector2(screen_size.x/2,screen_size.y/2)

enum State {OnParty, Sequenced, Static}
var state = null





func _ready():
	camera.process_mode = Camera2D.CAMERA2D_PROCESS_PHYSICS
	add_child(camera)
	camera.current = true
	
	tween.playback_process_mode = Tween.TWEEN_PROCESS_PHYSICS
	add_child(tween)
	
	
	
	
#Run camera movement in physics process?
# Use signals for state changes rather than process constant checks
func _physics_process(delta):	
	print(state)
	
	
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() != 1:
		if state != State.Static and state != State.Sequenced: state_to_static()
	else:
		if state != State.OnParty and state != State.Sequenced: state_to_party()
	
	
	if state == State.Static:
		return
	elif state == State.OnParty:
		var party_pos = party[0].active_player.get_global_position()
		position = Vector2(party_pos.x, party_pos.y)
		if "camera_bounds" in SceneManager.current_scene:
			var bounds = SceneManager.current_scene.camera_bounds
			position.x = clamp(position.x, bounds["min_x"], bounds["max_x"])
			position.y = clamp(position.y, bounds["min_y"], bounds["max_y"])
		#position = Vector2(round(position.x), round(position.y))
		camera.align()
	elif state == State.Sequenced:
		position = Vector2(round(position.x), round(position.y))
		camera.align()
		return
	else:
		Debugger.dprint("ERROR: Invalid Camera Manager State")
	
	
func move_to_position(destination : Vector2, time : float):
	tween.interpolate_property(self, "position", position, destination, time)
	tween.start()
	yield(tween, "tween_completed")
	
	
func move_to_party(time : float):
	var destination = Vector2(0,0)
	var party = get_tree().get_nodes_in_group("Party")
	if party.size() == 1:
		destination = party[0].active_player.get_global_position()
	move_to_position(destination, time)


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
	position = static_pos
	
func state_to_sequenced():
	state = State.Sequenced

