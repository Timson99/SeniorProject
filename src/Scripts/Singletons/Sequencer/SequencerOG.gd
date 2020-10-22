extends Node

var in_control = false


var Events = preload("res://Scripts/Resource_Scripts/EventSequences.gd").new()

var active_events = []
var current_instruction = null
var last_actor_instruction_type = null


func _ready():
	pass
	
func assume_control():
	in_control = true
	InputEngine.disable_player_input()
	
func end_control():
	in_control = false
	InputEngine.enable_all()
	
	
	
func _process(_delta):
	if in_control and active_events.size() == 0:
		end_control()
	elif !in_control and active_events.size() > 0:
		assume_control()
		
	var indices_to_remove = []
		
	for i in range(active_events.size()):
		var event = active_events[i]
		if(event["current_instruction"] != null && event["current_instruction"].is_valid()):
			return
		if event["instructions"].size() == 0:
			indices_to_remove.append(i)
			break
		var instruction = event["instructions"].pop_front()
		if instruction.size() >= 3 && (instruction[0] == "Actor-sync" || instruction[0] == "Actor-async"):	
			event["current_instruction"] = actor_instruction(instruction)
		elif instruction.size() >= 2 && instruction[0] == "BG_Audio":
			event["current_instruction"] = bg_audio_instruction(instruction)
		elif instruction.size() == 2 && instruction[0] == "Dialogue":
			event["current_instruction"] = dialogue_instruction(instruction[1])
		elif instruction.size() == 3 && instruction[0] == "Scene":
			event["current_instruction"] = scene_instruction(instruction[1], instruction[2])
		elif instruction.size() == 2 && instruction[0] == "Battle":
			event["current_instruction"] = battle_instruction(instruction[1])
		elif instruction.size() >= 2 && instruction[0] == "Camera":
			instruction.pop_front()
			event["current_instruction"] = camera_instruction(instruction)
		elif instruction.size() == 2 && instruction[0] == "Delay":
			event["current_instruction"] = delay_instruction(instruction[1])
		elif instruction.size() == 3 && instruction[0] == "Signal":
			event["current_instruction"] = signal_instruction(instruction[1], instruction[2])
		else:
			Debugger.dprint("Error: Instruction Not Valid")
			
	for index in indices_to_remove:
		active_events.remove(index)
		

func execute_event(event_id : String):
	if not event_id in Events.sequences :
		Debugger.dprint("ERROR: Invalid Event")
		return
	
	var event = load(Events.sequences[event_id])
	var instructions = event.instructions()
	active_events.append({"event_id" : event_id, 
						  "instructions" : instructions,
						  "current_instruction" : null })
	
	
		
func actor_instruction(params: Array):
	# If an instruction is called for an actor already executing a command,
	# the new instruction will NOT be processed by the Actor Engine until 
	# ALL asynchronous actions have finished.
	if ActorEngine.actors_dict[params[1]] in ActorEngine.asynchronous_actors_dict:
		if ActorEngine.asynchronous_delay_time > 0:
			yield(get_tree().create_timer(ActorEngine.asynchronous_delay_time, false), "timeout")
			ActorEngine.asynchronous_delay_time = 0.0
			
	# Note: params unpacked here to simplify code for process_command()
	if params.size() == 3:
		ActorEngine.process_command(params[0], params[1], params[2])
	elif params.size() == 4:
		ActorEngine.process_command(params[0], params[1], params[2], params[3])
	elif params.size() == 5:
		ActorEngine.process_command(params[0], params[1], params[2], params[3], params[4])
	if params[0] == "Actor-sync":
		yield(ActorEngine, "sync_command_complete")
	return
	

func bg_audio_instruction(params: Array):
	if params.size() == 2:
		BgEngine.call_deferred(params[1])
	elif params.size() == 3:
		BgEngine.call_deferred(params[1], params[2])
	elif params.size() == 4:
		BgEngine.call_deferred(params[1], params[2], params[4])
	print(params)
	yield(BgEngine, "audio_finished")
	return
	
	
# Open Dialogue, No Coroutine
func dialogue_instruction(dialogue_id : String):
	print(dialogue_id)
	return

#Begin Battle, No Coroutine, Last Instruction
func battle_instruction(scene_id : String):
	SceneManager.goto_scene(scene_id, "", true)
	yield(SceneManager, "scene_fully_loaded")
	return

#Change Scene, No Coroutine, Last Instruction
func scene_instruction(scene_id : String, warp_id : String):
	SceneManager.goto_scene(scene_id, warp_id)
	yield(SceneManager, "scene_fully_loaded")
	return
	
func camera_instruction(params : Array):
	if params[0] == "move_to_party":
		if params.size() == 2: 
			 CameraManager.move_to_party(params[1])
			 yield(CameraManager.tween, "tween_completed")	
			 CameraManager.release_camera() 
			 return
	if params[0] == "move_to_position":
		if params.size() == 3: 
			if CameraManager.grab_camera():
				CameraManager.move_to_position(params[1], params[2])
				yield(CameraManager.tween, "tween_completed")
			return
	else:
		Debugger.dprint("Sequencer Error: Wrong Number of ARGS for " + params[0])
		

func delay_instruction(time : float):
	yield(get_tree().create_timer(time, false), "timeout")
	return

func signal_instruction(obj_id : String, signal_name):
	var observed_objects = {
		#"Dialogue" : DialogueManager,
		"Scene" : SceneManager,
	}
	yield(observed_objects[obj_id], signal_name)
	return
