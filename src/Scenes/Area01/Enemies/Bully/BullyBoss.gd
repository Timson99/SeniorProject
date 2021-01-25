extends BossEnemy

	
	
var attempt_one_alive = true
var attempt_two_alive = true

var starting_pos = Vector2(-160,242)
var faint_pos = Vector2(-50, 254)



func _ready():
	._ready()
	
func on_load():
	#Only For When Backtracking from House
	if !attempt_one_alive and SceneManager.current_scene.current_attempt == 1: 
		Sequencer.execute_event("Area01_Sequence04")
	elif !attempt_two_alive and SceneManager.current_scene.current_attempt == 2: 
		Sequencer.execute_event("Area01_Sequence04")
	else:
		position = starting_pos

func post_battle():
	var outside_root = SceneManager.current_scene
	var attempt = outside_root.current_attempt
	if attempt == 1:
		outside_root.remove_vertical_event_trigger("pre_fight")
		attempt_one_alive = false
		position = faint_pos
		flip_horizontal(true)
		Sequencer.execute_event("Area01_Sequence04")
	elif attempt == 2:
		outside_root.remove_vertical_event_trigger("pre_fight")
		attempt_two_alive = false
		position = faint_pos
		flip_horizontal(true)
		Sequencer.execute_event("Area01_Sequence05")
	else:
		Debugger.dprint("Error in Bully Boss Script")

func save():
	var save_dict = {
		"persistence_id" : persistence_id,
		"position" : position, 
		"current_dir" : current_dir,
		"alive" : alive,
		"attempt_one_alive" : attempt_one_alive,
		"attempt_two_alive" : attempt_two_alive,
	}	
	return save_dict
